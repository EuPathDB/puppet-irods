# installs resource server
class irods::resource (
  String    $core_version     = $irods::params::core_version,
  Boolean   $do_setup         = $irods::params::do_setup,
  Boolean   $use_ssl          = $irods::globals::use_ssl,
  Boolean   $install_dev_pkgs = $irods::globals::install_dev_pkgs,
) inherits irods::params {

  include ::irods::service

  contain irods::resource::setup
  Irods::Lib::Install['resource'] ~>
  Class['irods::resource::setup'] ->
  Irods::Lib::Ssl['resource']

  $min_packages = ['irods-resource']
  if $install_dev_pkgs {
    $packages = concat($min_packages, ['irods-dev', 'irods-runtime'])
  } else {
    $packages = $min_packages
  }

  irods::lib::install { 'resource':
    packages     => $packages,
    core_version => $core_version,
  }

  if $use_ssl {
    irods::lib::ssl { 'resource':
      ssl_certificate_chain_file_source => $irods::globals::ssl_certificate_chain_file_source,
      ssl_certificate_key_file_source   => $irods::globals::ssl_certificate_key_file_source,
    }
  }

}
