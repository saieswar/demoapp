# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'rubygems'
require 'rake'

namespace :static_data do
	task :reset_data => :environment do
		
		puts "Services created!"
		Service.destroy_all
	  Service.create(id: 1, name: "MLS Listing")
		Service.create(id: 2, name: "Open Houses")
		Service.create(id: 3, name: "Photography")
		Service.create(id: 4, name: "Virtual Home Tour")
		Service.create(id: 5, name: "Zillow Listing")
		Service.create(id: 6, name: "Realtor.com Listing")
		Service.create(id: 7, name: "Open Houses")

    puts "Roles created!"
    Role.destroy_all
		Role.create(id:1, name: "Agent")
		Role.create(id:1, name: "Seller")

		puts "Property types created!"
    PropertyType.create(id: 1, name: "Single Family")
    PropertyType.create(id: 2, name: "Multi Family")
    PropertyType.create(id: 3, name: "Condominium")
    PropertyType.create(id: 4, name: "Townhouse/Rowhouse")
    PropertyType.create(id: 5, name: "Apartment")
    PropertyType.create(id: 6, name: "Loft")

   BidStatus.destroy_all
		puts "BidStatus created!"
		BidStatus.create(id: 1, status: "Bid Pending")
		BidStatus.create(id: 2, status: "Bid Accepted")
    BidStatus.create(id: 3, status: "Bid Rejected")
    BidStatus.create(id: 4, status: "Bid Won")
    BidStatus.create(id: 5, status: "Bid Lost")
    BidStatus.create(id: 6, status: "Bid Cancelled")
    


	end
end