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
    #Usa a função search por causa da pesquisa por palavras chave e ordenação -> ver Modelo JobOffer
    @offers = @company.job_offers.search(params[:search], params[:order]).paginate(:page => params[:page], :per_page => 5)
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

    if @candidate.valid?
      
      if params[:cv_type] == 'linkedin'     #Se for um post para linkedin

        #começa o processo de autenticação no linkedin
        generate_linkedin_oauth_url @candidate

      elsif params[:cv_type] == 'xml'     #Se for um post para xml

        session[:file] = params[:file].path
        session[:candidate] = @candidate

        redirect_to xml_profile_path params[:company_id],params[:id]

      else     #Se for um post para pdf

        session[:file] = params[:file].path
        session[:candidate] = @candidate

        redirect_to pdf_profile_path params[:company_id],params[:id]
      end

    else
      flash[:alert] = "Something went wrong, try again."
      redirect_to new_apply_path(params[:company_id])
    end
  end

  def xml_profile
    xml_contents = File.open(session[:file],'r')
    session.delete(:file)

    @file_text = readXMLfile2html(xml_contents)
    session[:file_path] = 'app/assets/candidaturas/'+Time.now.to_i.to_s+'.html'
    File.open(session[:file_path],'w') do |file|
      file.write(@file_text)
    end

    @file_text = @file_text.html_safe
    @candidate = session[:candidate]
  end

  def pdf_profile

    session[:file_path] = 'public/'+Time.now.to_i.to_s+'.pdf'
    File.open(session[:file_path],'w') do |file|
      file.write(File.read(session[:file]))
    end

    @file_pdf = session[:file_path]
    @candidate = session[:candidate]
    session.delete(:file)
  end

  #Esta acção guarda efectivamente um CV carregado através do LinkedIn
  def save_linkedin_profile
    #Obter variáveis guardadas na session
    @candidate = session[:candidate]
    @profile = session[:profile]

    if @candidate.save

      #Guarda o ficheiro HTML com o perfil e actualiza o Model com o file path
      @candidate.file_path = save_linkedin_to_html(@profile,@candidate)
      #Save novamente faz update
      @candidate.save
      #Limpa as variáveis de sessão
      session[:candidate] = nil
      session[:profile] = nil

      flash[:success] = "Profile successfully saved."
      redirect_to public_company_job_offers_path(params[:company_id])
    else
      flash[:alert] = "Could not save, please retry."
      redirect_to public_company_job_offers_path(params[:company_id])
    end
  end

  #Esta acção guarda efectivamente um CV carregado através de XML
  def save_xml_profile
    #Obter variáveis guardadas na session
    @candidate = session[:candidate]
    session.delete(:candidate)


    if @candidate.save

      path = 'app/assets/candidaturas/'+@candidate.id.to_s+'.html'

      #Open faz open ou create, nice :)
      File.open(path,'w') do |file|
        file.write(File.read(session[:file_path]))
      end

      File.delete(session[:file_path])
      session.delete(:file_path)

      #Guarda o ficheiro HTML com o perfil e actualiza o Model com o file path
      @candidate.file_path = path
      #Save novamente faz update
      @candidate.save

      flash[:success] = "Profile successfully saved."
      redirect_to public_company_job_offers_path(params[:company_id])
    else
      flash[:alert] = "Could not save, please retry."
      redirect_to public_company_job_offers_path(params[:company_id])
    end
  end

  #Esta acção guarda efectivamente um CV carregado através de XML
  def save_pdf_profile
    #Obter variáveis guardadas na session
    @candidate = session[:candidate]
    session.delete(:candidate)

    if @candidate.save

      path = 'app/assets/candidaturas/'+@candidate.id.to_s+'.pdf'

      #Open faz open ou create, nice :)
      File.open(path,'w') do |file|
        file.write(File.read(session[:file_path]))
      end

      File.delete(session[:file_path])
      session.delete(:file_path)

      #Guarda o ficheiro HTML com o perfil e actualiza o Model com o file path
      @candidate.file_path = path
      #Save novamente faz update
      @candidate.save

      flash[:success] = "Profile successfully saved."
      redirect_to public_company_job_offers_path(params[:company_id])
    else
      flash[:alert] = "Could not save, please retry."
      redirect_to public_company_job_offers_path(params[:company_id])
    end
  end

  def cancel_profile
    session.delete(:candidate)
    File.delete(session[:file_path])
    session.delete(:file_path)
    redirect_to new_apply_path(params[:company_id],params[:id])
  end

  ######################################################################################################################
  # FUNÇÕES NECESSÁRIAS
  ######################################################################################################################

  def readXMLfile2html(xmlf)
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
      fileHTML += "</table>"
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
      fileHTML += "</table>"
    end

    fileHTML += "</div>"

    return fileHTML
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

    #encaminha para o mostrador de perfil obtido"
    redirect_to linkedin_profile_path @company,@job_offer,@candidate
  end

  #Mostra o perfil
  def linkedin_profile
    @candidate = session[:candidate]
    @profile = get_full_profile
    #guarda temporariamente na session
    session[:profile] = @profile
  end

  #Obtem e devolve o perfil do utilizador actual do linkedin.
  def get_full_profile
    #Novo cliente
    client = LinkedIn::Client.new(@@api_key, @@api_secret, @@configuration)
    #Autorização
    client.authorize_from_access(@@accesstoken,@@accesssecret)
    #SACA O PERFIL!!!
    profile = client.profile(:fields => [:positions ,:educations , :skills])
    #Transforma-o em algo útil
    full_profile = profile.to_hash
    #Devolve
    return full_profile
  end

  #Grava o ficheiro com o HTML retirado do perfil do LinkedIn
  def save_linkedin_to_html(profile,candidate)
    fileHTML = "<div>"

    #Experiência Profissional
    fileHTML += "<h1>Work Experience</h1>"

    profile["positions"]["all"].each do |pos|
      fileHTML += "<table>"
      fileHTML += "<tr><td align='right'><b>From:</b></td><td>"
      fileHTML += pos.start_date["year"].to_s
      fileHTML += "</td></tr>"
      fileHTML += "<tr><td align='right'><b>To:</b></td><td>"
      if(pos.is_current) #Caso seja o empre actual
        fileHTML += "Current"
      else
        fileHTML += pos.end_date["year"].to_s
      end
      fileHTML += "</td></tr>"
      fileHTML += "<tr><td align='right'><b>Position:</b></td><td>"+pos.title+"</td></tr>"
      fileHTML += "<tr><td align='right'><b>Company:</b></td><td>"+pos.company["name"]+"</td></tr>"
      fileHTML += "</table><hr>"
    end

    #Habilitações
    fileHTML += "<h1>Education</h1>"

    profile["educations"]["all"].each do |edu|
      fileHTML += "<table>"
      fileHTML += "<tr><td align='right'><b>From:</b></td><td>"
      fileHTML += edu.start_date["year"].to_s
      fileHTML += "</td></tr>"
      fileHTML += "<tr><td align='right'><b>To:</b></td><td>"
      fileHTML += edu.end_date["year"].to_s
      fileHTML += "</td></tr>"
      fileHTML += "<tr><td align='right'><b>Degree:</b></td><td>"+edu.degree+"</td></tr>"
      fileHTML += "<tr><td align='right'><b>Field of Study:</b></td><td>"+edu.field_of_study+"</td></tr>"
      fileHTML += "<tr><td align='right'><b>Organization:</b></td><td>"+edu.school_name+"</td></tr>"
      fileHTML += "</table><hr>"
    end

    #Habilidades/Conhecimentos
    fileHTML += "<h1>Skills</h1>"

    profile["skills"]["all"].each do |skill|
      fileHTML += "<table>"
      fileHTML += "<tr><td align='right'><b>Name:</b></td><td>"
      fileHTML += skill["skill"].name
      fileHTML += "</td></tr>"
      fileHTML += "</table><hr>"
    end

    fileHTML += "</div>"

    #Open faz open ou create, nice :)
    File.open('app/assets/candidaturas/'+"#{candidate.id}"+'.html','w') do |file|
      file.write(fileHTML)
    end

    #Retorna onde foi guardado. Provavelmente deveria fazer um teste antes
    return  'app/assets/candidaturas/'+"#{candidate.id}"+'.html'
  end

end
