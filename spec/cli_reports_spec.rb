require 'spec_helper'
require 'proptax/cli'

describe Proptax::CLI, :type => :aruba do
    
  before :each do
    FileUtils.cp_r 'spec/aruba_data', 'tmp/aruba/aruba_data'
  end

  describe 'reports' do
    it "creates a `reports` directory" do
      expect(exist?('reports/')).to be false

      run_simple 'proptax reports aruba_data/'
      expect(last_command_started).to be_successfully_executed

      expect(exist?('reports/')).to be true
    end 

    it "creates markdown files for R and final typeset PDF" do
      run_simple 'proptax reports aruba_data/'
      expect(last_command_started).to be_successfully_executed

      expect(file?('reports/11363_ROCKYVALLEY_DR_NW.md')).to be true
      expect(file?('reports/11363_ROCKYVALLEY_DR_NW.pdf')).to be true
      expect(file?('reports/11363_ROCKYVALLEY_DR_NW.Rmd')).to be true
      expect(file?('reports/11367_ROCKYVALLEY_DR_NW.md')).to be true
      expect(file?('reports/11367_ROCKYVALLEY_DR_NW.pdf')).to be true
      expect(file?('reports/11367_ROCKYVALLEY_DR_NW.Rmd')).to be true
    end 

    it "writes the correct R markdown to the files" do
      run_simple 'proptax reports aruba_data/'

      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11363 ROCKYVALLEY DR NW"/)
      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 492500/)
      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "aruba_data\/\/consolidated.csv"/)
      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-10000, max\(assessedValues\)\+10000\)\) \+/)

      expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/address <- "11367 ROCKYVALLEY DR NW"/)
      expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/myAssessedValue <- 512000/)
      expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/csvFile <- "aruba_data\/\/consolidated.csv"/)
      expect('reports/11367_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/scale_y_continuous\(labels=dollar, breaks=pretty_breaks\(n=10\),/)
      expect('reports/11363_ROCKYVALLEY_DR_NW.Rmd').to have_file_content(/limits=c\(min\(assessedValues\)-10000, max\(assessedValues\)\+10000\)\) \+/)
    end 
  end
end