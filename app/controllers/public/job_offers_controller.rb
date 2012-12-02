class Public::JobOffersController < Public::ApplicationController
  layout "nolayout"

  #Chaves da API do LinkedIn para esta aplicação
  @@api_key =  'gdpw09c8khsp'
  @@api_secret = 'GjOzGtusFpJ2e9as'
  @@user_token = '1b7ef419-844d-4c26-8807-aa9f5fa39d96'
  @@user_secret = '00d5f1bf-5d30-45c8-b6cf-e9ce33822a51'

  @@pin = nil
  @@accesssecret = nil
  @@accesstoken = nil

  #Hash de configuração usada pela gem oauth e/ou linkedin
  @@configuration =   { :site => 'https://api.linkedin.com',
                        :authorize_path => '/uas/oauth/authenticate',
                        :request_token_path => '/uas/oauth/requestToken?scope=r_fullprofile',
                        :access_token_path => '/uas/oauth/accessToken',
                        :callback_url => 'http://localhost:3000/linkedin_callback' }

  ######################################################################################################################

  def index
    @company = Company.find(params[:company_id])
    @offers = @company.job_offers.paginate(:page => params[:page], :per_page => 10)
  end

  def show
      @offer = JobOffer.find(params[:id])
      @company = @offer.company
  end

  def new
    @offer = JobOffer.find(params[:id])
    @company = @offer.company
    @candidate = Candidate.new
    @candidate.job_offer_id = @offer.id
  end

  def create
    @candidate = Candidate.new(params[:candidate])
    @candidate.job_offer_id = params[:id]

    if @candidate.save
      
      if params[:cv_type] == 'linkedin'     #Se for um post para linkedin
        #começa o processo de autenticação no linkedin
        generate_linkedin_oauth_url @candidate
      elsif params[:cv_type] == 'xml'     #Se for um post para xml
        file_data = params[:file]
        xml_contents = file_data.read
        readXMLfile2html(xml_contents,@candidate.id.to_s)
      end

      flash[:success] = "You applied successfully for the job."
      redirect_to public_company_job_offers_path(params[:company_id])
    else
      #format.html { render action: "new" }
      #format.json { render json: @candidate.errors, status: :unprocessable_entity }
      flash[:alert] = "Something went wrong, try again."
      redirect_to new_apply_path(params[:company_id])
    end
  end

  ######################################################################################################################
  # FUNÇÕES NECESSÁRIAS
  ######################################################################################################################

  def readXMLfile2html(xmlf,id)
    doc = Hpricot::XML(xmlf)
    fileHTML = "<div>"

    #Experiência Profissional
    fileHTML += "<h1>Work Experience</h1>"

    (doc/:"europass:learnerinfo"/:workexperiencelist/:workexperience).each do |we|
      fileHTML += "<table>"
      if !(we).at('period/from').innerHTML.blank?
        fileHTML += "<tr><td align='right'><b>From:</b></td><td>"
        if !(we).at('period/from/month').blank?
          fileHTML += (we).at('period/from/month').innerHTML.split("--")[1]+" - "
        end
        if !(we).at('period/from/year').blank?
          fileHTML += (we).at('period/from/year').innerHTML
        end
        fileHTML += "</td></tr>"
      end
      if !(we).at('period/to').innerHTML.blank?
        fileHTML += "<tr><td align='right'><b>To:</b></td><td>"
        if !(we).at('period/to/month').blank?
          fileHTML += (we).at('period/to/month').innerHTML.split("--")[1]+" - "
        end
        if !(we).at('period/to/year').blank?
          fileHTML += (we).at('period/to/year').innerHTML
        end
        fileHTML += "</td></tr>"
      end
      if !(we).at('position/label').blank?
        fileHTML += "<tr><td align='right'><b>Position:</b></td><td>"+(we).at('position/label').innerHTML+"</td></tr>"
      end
      if !(we).at('activities').blank?
        fileHTML += "<tr><td align='right'><b>Activities:</b></td><td>"+(we).at('activities').innerHTML+"</td></tr>"
      end
      if !(we).at('employer/name').blank?
        fileHTML += "<tr><td align='right'><b>Employer:</b></td><td>"+(we).at('employer/name').innerHTML+"</td></tr>"
      end
      fileHTML += "</table><hr>"
    end

    #Habilitações
    fileHTML += "<h1>Education</h1>"

    (doc/:"europass:learnerinfo"/:educationlist/:education).each do |edu|
      fileHTML += "<table>"
      if !(edu).at('period/from').innerHTML.blank?
        fileHTML += "<tr><td align='right'><b>From:</b></td><td>"
        if !(edu).at('period/from/month').blank?
          fileHTML += (edu).at('period/from/month').innerHTML.split("--")[1]+" - "
        end
        if !(edu).at('period/from/year').blank?
          fileHTML += (edu).at('period/from/year').innerHTML
        end
        fileHTML += "</td></tr>"
      end
      if !(edu).at('period/to').innerHTML.blank?
        fileHTML += "<tr><td align='right'><b>From:</b></td><td>"
        if !(edu).at('period/to/month').blank?
          fileHTML += (edu).at('period/to/month').innerHTML.split("--")[1]+" - "
        end
        if !(edu).at('period/to/year').blank?
          fileHTML += (edu).at('period/to/year').innerHTML
        end
        fileHTML += "</td></tr>"
      end
      if !(edu).at('title').blank? 
        fileHTML += "<tr><td align='right'><b>Title:</b></td><td>"+(edu).at('title').innerHTML+"</td></tr>"
      end
      if !(edu).at('skills').blank? 
        fileHTML += "<tr><td align='right'><b>Skills:</b></td><td>"+(edu).at('skills').innerHTML+"</td></tr>"
      end
      if !(edu).at('organisation/name').blank? 
        fileHTML += "<tr><td align='right'><b>Organization:</b></td><td>"+(edu).at('organisation/name').innerHTML+"</td></tr>"
      end
      fileHTML += "</table><hr>"
    end

    fileHTML += "</div>"

    File.open('app/assets/candidaturas/'+id+'.html','w') do |file|
      file.write(fileHTML)
    end
  end


  ### LINKEDIN

  def generate_linkedin_oauth_url(candidate)
    client = LinkedIn::Client.new(@@api_key, @@api_secret, @@configuration)

    #MUITO IMPORTANTE - esta linha define para onde é esperado de volta a resposta ao request por parte do linkedin
    request_token = client.request_token(:oauth_callback => "#{linkedin_oauth_url}")

    #grava na session os parametros dos tokens do utilizador
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    #prega o candidate actual na session para não se perder com o reencaminhamento
    session[:candidate] = candidate

    #envia o utilizador para o url de autorizaçao do linkedin
    redirect_to request_token.authorize_url

  end

  def oauth_account
    #Cria um cliente Linkedin com as credenciais actuais
    client = LinkedIn::Client.new(@@api_key, @@api_secret, @@configuration)

    #vai buscar o código enviado pelo linkedin
    @@pin = params[:oauth_verifier]

    #busca as variáveis potencialmente necessárias
    @candidate = session[:candidate]
    @job_offer = JobOffer.find(params[:id])
    @company = Company.find(params[:company_id])

    if @@pin
      #trata das autorizações
      @@accesstoken, @@accesssecret = client.authorize_from_request(session[:rtoken], session[:rsecret], @@pin)
    end

    #encaminha para o mostrador de perfil obtido
    redirect_to linkedin_profile_path @company,@job_offer,@candidate
  end

  #Mostra o perfil
  def linkedin_profile
    @candidate = session[:candidate]
    @profile = get_full_profile
  end

  def get_full_profile
    #Novo cliente
    client = LinkedIn::Client.new(@@api_key, @@api_secret, @@configuration)
    #Autorização
    client.authorize_from_access(@@accesstoken,@@accesssecret)

    #SACA O PERFIL!!!
    profile = client.profile(:fields => [:specialties , :skills])
    #Transforma-o em algo útil
    full_profile = profile.to_hash

    #Devolve
    return full_profile
  end

end
