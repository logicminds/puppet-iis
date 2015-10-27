require File.join(File.dirname(__FILE__), 'iis/iis_file_system_path_property')

Puppet::Type.newtype(:iis_config) do
  @doc = "IIS config"

  ensurable


end
