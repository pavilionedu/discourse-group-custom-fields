import { withPluginApi } from 'discourse/lib/plugin-api';

export default {
  name: 'group-custom-field',
  initialize() {
    withPluginApi('0.8.30', api => {
      api.modifyClass('model:group', {
        // The custom_fields attribute is initialzed as an empty object on the
        // group model so we can add to it in the template.
        // i.e we're using custom_fields.my_field in connectors/group-edit/field-container.hbs
        custom_fields: {},
        
        // STEP 2 //
        // Here we're adding custom_fields to the json object that's
        // that's sent to the server
        asJSON() {
          return Object.assign(this._super(), {
            custom_fields: this.custom_fields
          });
        }
      })
    })
  }
}