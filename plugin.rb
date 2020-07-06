# frozen_string_literal: true

# name: discourse-education-group-custom-fields
# about: Education example: Add a custom field to a group
# version: 0.1
# authors: Angus McLeod
# url: https://github.com/paviliondev/discourse-education-group-custom-fields

after_initialize do
  
  ## STEP 3 - Controllers and whitelisting ##
  ## Adds custom field to strong parameter lists (allows it down to the server)
  ## This is a new hook that has been added to make it easier to add group custom fields
  DiscoursePluginRegistry.register_editable_group_custom_field(:my_field, self)
  
  ## STEP 4 - Saving the data ##
  ## In this case the same process that saves normal Discourse data will take care 
  ## of custom fields, as long as they get passed the strong parameter check
  ## See https://github.com/discourse/discourse/blob/master/app/controllers/groups_controller.rb#L145
  
  ## STEP 5 - Data type handling and standardisation ##
  ## Our data could be boolean, a string, json, an array and various other types. We need to add some
  ## explicit type handling to ensure data is saved and retrieved consistently. Discourse provides 
  ## for 3 data types in custom_fields: string (default); boolean and json. You can tell the system
  ## that handles custom fields to cast a particular field as one of the three types by using a
  ## server side plugin api helper method
  register_group_custom_field_type('my_field', :boolean)
  
  
  ## STEP 6 - Serialization ##
  ## Now that the data is saved and the data is standardized, we have to make sure it gets back up to the client
  ## To do that we have to "serialize" it along with the group model. The add_to_serializer method is a helper
  ## method for patching discourse serializers. You can find it in plugin/instance.rb. 
  ## In this case we're using the custom_fields namespace to handle our data on the client
  ## so we can just serialize all group custom fields to the client and it will work. There are
  ## more targeted ways to serialize only what's needed in specific contexts but this serves our purposes
  ## for now.
  add_to_serializer(:basic_group, :custom_fields) { object.custom_fields }
  
end