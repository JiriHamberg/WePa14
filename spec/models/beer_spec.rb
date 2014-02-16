require 'spec_helper'

describe Beer do
  it "is not saved without a name" do
    beer = Beer.create style: FactoryGirl.create(:style)
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"Karu V"
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is saved if name and style are provided" do
    beer = Beer.create name:"Karu V", style:FactoryGirl.create(:style)
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
end
