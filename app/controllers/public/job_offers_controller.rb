class Public::JobOffersController < Public::ApplicationController
  layout "nolayout"

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
      flash[:success] = "You applied successfully for the job."
      redirect_to public_company_job_offers_path(params[:company_id])
    else
      flash[:alert] = "Something went wrong, try again."
      redirect_to new_apply_path(params[:company_id])
    end
  end

  def create_xml
    @candidate = Candidate.new(params[:candidate])
    @candidate.job_offer_id = params[:id]

    if @candidate.save
        
      file_data = params[:file]
      xml_contents = file_data.read

      readXMLfile2html(xml_contents,@candidate.id.to_s)
      flash[:success] = "You applied successfully for the job."
      redirect_to public_company_job_offers_path(params[:company_id])
    else
      flash[:alert] = "Something went wrong, try again."
      redirect_to new_apply_path(params[:company_id])
    end
  end

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

end
