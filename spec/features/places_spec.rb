require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:name => "Oljenkorsi", :id  => 1) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, shows all at the page" do
    names = ["Oljenkorsi", "Olutkellari", "Ooster"]
    id = 0
    places = names.inject([]) do |list, name|
      list << Place.new(:name => name, :id => id+=1)
    end
    BeermappingApi.stub(:places_in).with("kumpula").and_return places
    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
    names.each do |name|
      expect(page).to have_content name
    end
  end

  it "if none are returned by the API, user will be notified" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return []

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "No locations in kumpula"
  end

end