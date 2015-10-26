if Rails.configuration.gulp[:use_manifest]
  js_manifest  = Rails.root.join('public', 'assets', '.gulp-js-manifest.json')
  css_manifest = Rails.root.join('public', 'assets', '.gulp-css-manifest.json')

  Rails.configuration.gulp[:js_manifest] = JSON.parse(
    File.read js_manifest
  ).with_indifferent_access if File.exist? js_manifest

  Rails.configuration.gulp[:css_manifest] = JSON.parse(
    File.read css_manifest
  ).with_indifferent_access if File.exist? css_manifest
end
