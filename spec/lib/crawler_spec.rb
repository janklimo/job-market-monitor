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
    stub_request(
      :get,
      "http://marketdata.set.or.th/mkt/sectorialindices.do"
    ).to_return(status: 200, body: set_index_html)
    stub_request(
      :get,
      "http://www.jobnisit.com/en/jobs"
    ).to_return(status: 200, body: job_nisit_html)
    stub_request(
      :post,
      "http://www.jobnisit.com/en/jobs"
    ).to_return(status: 200, body: job_nisit_tech_html)
  end

  it 'fetches and stores data' do
    expect{task.invoke}.to change{ Entry.count }.by 1
    expect(Entry.last.jobs_db_total).to eq 16500
    expect(Entry.last.jobs_db_tech).to eq 2136
    expect(Entry.last.set_index).to eq 1492.95
    expect(Entry.last.job_nisit_total).to eq 2207
    expect(Entry.last.job_nisit_tech).to eq 130
  end

  context 'jobnisit breaks' do
    before do
      stub_request(:get, "http://www.jobnisit.com/en/jobs")
        .to_return(status: 500)
      stub_request(:post, "http://www.jobnisit.com/en/jobs")
        .to_return(status: 500)
      @entry = create(:entry)
    end
    it 'saves the rest, Jobnisit equals value from previous day' do
      expect{task.invoke}.to change{ Entry.count }.by 1
      expect(Entry.last.jobs_db_total).to eq 16500
      expect(Entry.last.jobs_db_tech).to eq 2136
      expect(Entry.last.set_index).to eq 1492.95
      expect(Entry.last.job_nisit_total).to eq @entry.job_nisit_total
      expect(Entry.last.job_nisit_tech).to eq @entry.job_nisit_tech
    end
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

def set_index_html
  <<-html
  <div id="maincontent" class="col-lg-12">
    <div class="row">
      <div class="col-xs-12 col-md-12 col-lg-12">
        <div class="table-responsive">
          <table class="table-info">
              <caption style="text-align: right;">
                  <span class="set-color-gray set-color-graylight">* Market data provided for educational purpose or personal use only, not intended for trading purpose.</span><br>
                  * Last Update 15 Jul 2016 22:59:57
              </caption>
              <thead>
                <tr>
                  <th>Index</th>
                  <th>Last</th>
                  <th>Change</th>
                  <th>%Change</th>
                  <th>High</th>
                  <th>Low</th>
                  <th>Volume<br>('000 Shares)</th>
                  <th>Value<br>(M.Baht)</th>
                </tr>
            </thead>
          <tbody>
            <tr>
              <td style="text-align: left;">
              SET
              </td>
              <td>1,492.95</td>
              <td><font style="color: green;">+3.31</font></td>
              <td><font style="color: green;">+0.22</font></td>
              <td>1,498.13</td>
              <td>1,489.82</td>
              <td>12,138,506</td>
              <td>59,275.04</td>
            </tr>
            <tr>
              <td style="text-align: left;">
                <a href="/mkt/sectorquotation.do?sector=SET50&amp;langauge=en&amp;country=US">SET50</a>
              </td>
              <td>942.95</td>
              <td><font style="color: green;">+0.20</font></td>
              <td><font style="color: green;">+0.02</font></td>
              <td>948.38</td>
              <td>941.50</td>
              <td>1,560,771</td>
              <td>34,958.61</td>
            </tr>
          </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
  html
end

def job_nisit_html
  <<-html
  <div style="float: left;width:100%; margin-bottom: -10px;">
    <h2 class="th " style="padding-left: 15px;  ">
    <span class="results-count" id="job_amount">
          1 - 25 of 2207
      </span><span class="th" style="font-size: 23px;"> jobs positions
        </span></h2>
    </div>
  html
end

def job_nisit_tech_html
  <<-html
  <div style="float: left;width:100%; margin-bottom: -10px;">
    <h2 class="th " style="padding-left: 15px;  ">
    <span class="results-count" id="job_amount">
          1 - 25 of 130
      </span><span class="th" style="font-size: 23px;"> jobs positions
        </span></h2>
    </div>
  html
end
