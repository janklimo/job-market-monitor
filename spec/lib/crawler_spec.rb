describe 'crawler:run' do
  include_context 'rake'

  before do
    stub_request(
      :get,
      "http://th.jobsdb.com/TH/EN/Search/FindJobs" \
        "?JSRV=1&JobCat=1&KeyOpt=COMPLEX&RLRSF=1"
    ).to_return(status: 200, body: jobs_db_all_html)
    stub_request(
      :get,
      "http://th.jobsdb.com/TH/EN/Search/FindJobs" \
        "?KeyOpt=COMPLEX&JSRV=1&RLRSF=1&JobCat=131&JSSRC=JSRSB"
    ).to_return(status: 200, body: jobs_db_tech_html)
  end

  it 'fetches and stores data' do
    expect{task.invoke}.to change{ Entry.count }.by 1
    expect(Entry.last.jobs_db_total).to eq 16500
    expect(Entry.last.jobs_db_tech).to eq 2136
  end
end

def jobs_db_all_html
  <<-html
    <html>
      <div class="nav-secondary-body" id="JLsubNav">
          <div id="searchResultSecondaryBarShort" class="secondarybar-short job-search-criteria has-more expanded">
              <div id="primaryCriteriaContainerShort" class="job-search-criteria-details">
                <h1 class="criteria-container">
                  <span id="firstLineCriteriaContainer" class="criteria-primary"><em>16500</em>  jobs in <b>All locations</b></span>
                  <span id="secondLineCriteriaContainer" class="criteria-secondary"></span>
                </h1>
              </div>
              <div class="job-search-criteria-edit">
                <a class="criteria-edit-link"><span>Edit Search</span></a>
              </div>
          </div>
      </div>
    </html>
  html
end

def jobs_db_tech_html
  <<-html
    <html>
      <div class="nav-secondary-body" id="JLsubNav">
        <div id="searchResultSecondaryBarShort" class="secondarybar-short job-search-criteria has-more">
            <div id="primaryCriteriaContainerShort" class="job-search-criteria-details" style="cursor: default;">
              <h1 class="criteria-container">
                <span id="firstLineCriteriaContainer" class="criteria-primary"><em>2136</em> <b>All Information Technology (IT)</b> jobs in <b>All locations</b></span>
                <span id="secondLineCriteriaContainer" class="criteria-secondary"></span>
              </h1>
            </div>
            <div class="job-search-criteria-edit">
              <a class="criteria-edit-link"><span>Edit Search</span></a>
            </div>
        </div>
      </div>
    </html>
  html
end
