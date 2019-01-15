# This file contains the fastlane.tools configuration
# You can find the documentation at https://docs.fastlane.tools
#
# For a list of all available actions, check out
#
#     https://docs.fastlane.tools/actions
#
# For a list of all available plugins, check out
#
#     https://docs.fastlane.tools/plugins/available-plugins
#

# Uncomment the line if you want fastlane to automatically update itself
# update_fastlane

default_platform(:ios)

def build_and_upload_to_testflight_with_scheme(scheme, bugly_app_key, bugly_app_id)
  app_identifier = CredentialsManager::AppfileConfig.try_fetch_value(:app_identifier)
  # ensure_git_status_clean
  disable_automatic_code_signing
  match(
      type: 'appstore',
      app_identifier: app_identifier,
      readonly: true)

  match(
      type: 'development',
      app_identifier: app_identifier,
      readonly: true)

  settings_to_override = {
      :PROVISIONING_PROFILE_SPECIFIER => "match Development #{app_identifier}"
  }

  ipa_name = "#{scheme}.ipa"
  build_app(
      scheme: scheme,
      xcargs: settings_to_override,
      export_method: "app-store",
      output_name: ipa_name,
      export_options: {
          provisioningProfiles: {
              app_identifier => "match AppStore #{app_identifier}"
          }
      }
  )

  upload_app_to_bugly(
      file_path: ipa_name,
      app_key: bugly_app_key,
      app_id: bugly_app_id,
      pid:"2",
      title:"title",
      desc:"description",
      )

  upload_to_testflight(skip_waiting_for_build_processing:true )


end

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :drone_online_beta do

    scheme = "LifeInGuangZhou"

    bugly_app_key = "52d1630f-be0a-4cab-8145-e4662b87446e"
    bugly_app_id = "6e66df30b1"

    build_and_upload_to_testflight_with_scheme(scheme, bugly_app_key, bugly_app_id)

  end

  lane :drone_test_beta do
    scheme = "LifeInGuangZhou"
    bugly_app_key = "52d1630f-be0a-4cab-8145-e4662b87446e"
    bugly_app_id = "6e66df30b1"

    build_and_upload_to_testflight_with_scheme(scheme, bugly_app_key, bugly_app_id)
  end

  lane :online_beta do
    ENV["MANUAL_FASTLANE"] = "YES"
    drone_online_beta
  end

  lane :test_beta do
    ENV["MANUAL_FASTLANE"] = "YES"
    drone_test_beta
  end

  lane :upload do
    upload_app_to_bugly(
        file_path:"LifeInGuangZhou.app.dSYM.zip",
        app_key:"52d1630f-be0a-4cab-8145-e4662b87446e",
        app_id:"6e66df30b1",
        pid:"2",
        title:"title",
        desc:"description",
        )
  end
end
