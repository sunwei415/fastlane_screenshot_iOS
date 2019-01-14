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

def build_and_upload_to_testflight_with_scheme(scheme)
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

  build_app(
      scheme: scheme,
      xcargs: settings_to_override,
      export_method: "app-store",
      export_options: {
          provisioningProfiles: {
              app_identifier => "match AppStore #{app_identifier}"
          }
      }
  )
  #upload_to_testflight(skip_waiting_for_build_processing:true )
  #reset_git_repo
end

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :drone_online_beta do

    scheme = "LifeInGuangZhou"

    build_and_upload_to_testflight_with_scheme(scheme)

  end
  lane :drone_test_beta do
    scheme = "LifeInGuangZhou"

    build_and_upload_to_testflight_with_scheme(scheme)
  end

  lane :online_beta do
    ENV["MANUAL_FASTLANE"] = "YES"
    drone_online_beta
  end

  lane :test_beta do
    ENV["MANUAL_FASTLANE"] = "YES"
    drone_test_beta
  end
end
