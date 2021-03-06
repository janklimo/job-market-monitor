require 'rest-client'

namespace :crawler do
  desc 'Fetch and store data'
  task run: :environment do
    entry = Entry.new

    # JobsDB
    jobs_db_all_url = 'http://th.jobsdb.com/TH/EN/Search/FindJobs' \
      '?KeyOpt=COMPLEX&JSRV=1&RLRSF=1&JobCat=1'
    jobs_db_all = Nokogiri::HTML(RestClient.get(jobs_db_all_url))
    jobs_db_all_count =
      jobs_db_all.css('span#firstLineCriteriaContainer em')[0].text.to_i
    entry.jobs_db_total = jobs_db_all_count

    jobs_db_tech_url = 'http://th.jobsdb.com/TH/EN/Search/FindJobs' \
      '?KeyOpt=COMPLEX&JSRV=1&RLRSF=1&JobCat=131&JSSRC=JSRSB'
    jobs_db_tech = Nokogiri::HTML(RestClient.get(jobs_db_tech_url))
    jobs_db_tech_count =
      jobs_db_tech.css('span#firstLineCriteriaContainer em')[0].text.to_i
    entry.jobs_db_tech = jobs_db_tech_count

    # SET Index
    set_index_url = "http://marketdata.set.or.th/mkt/sectorialindices.do"
    set_index_html = Nokogiri::HTML(RestClient.get(set_index_url))
    set_index_value =
      set_index_html.css('div#maincontent .table-responsive tbody tr')[0]
      .css('td')[1].text.gsub(',', '').to_f
    entry.set_index = set_index_value

    # Jobnisit
    job_nisit_url = "http://www.jobnisit.com/en/jobs"

    begin
      job_nisit_html = Nokogiri::HTML(RestClient.get(job_nisit_url))
      job_nisit_value =
        job_nisit_html.css('span.results-count')[0].text.match(/(?<=of\s)\d+/)[0]
      entry.job_nisit_total = job_nisit_value
    rescue
      entry.job_nisit_total = Entry.last.job_nisit_total
    end

    begin
      job_nisit_html = Nokogiri::HTML(
        RestClient.post(job_nisit_url, "industry_id=24")
      )
      job_nisit_tech_value =
        job_nisit_html.css('span.results-count')[0].text.match(/(?<=of\s)\d+/)[0]
      entry.job_nisit_tech = job_nisit_tech_value
    rescue
      entry.job_nisit_tech = Entry.last.job_nisit_tech
    end

    entry.save!
  end
end
