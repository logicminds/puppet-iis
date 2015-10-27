require File.join(File.dirname(__FILE__), 'iis/iis_file_system_path_property')

Puppet::Type.newtype(:iis_vdir) do
  @doc = "IIS Virtual Directory"

  ensurable

  newparam(:name, :namevar => true) do
    desc "Virtual directory name"
    newvalues(/.+\/.*/)
    validate do |value|
      unless value =~ /#{resource[:iis_app].chomp('/')}/
        raise ArgumentError("Name should start with #{resource[:iis_app].chomp('/')}")
      end
      unless value =~ /\w+\//
        raise ArgumentError("iis_vdir name value must end with a trailing slash")
      end
    end
  end

  newparam(:iis_app) do
    desc "Path of the app the virtual directory is under"
    validate do |value|
      unless value =~ /\w+\//
        raise ArgumentError("iis_vdir iis_app value must end with a trailing slash")
      end
    end

    isrequired
  end

  newproperty(:physicalpath, :parent => Puppet::IisFileSystemPathProperty) do
    desc "Physical path"
  end

  newproperty(:logonmethod, :parent => Puppet::IisProperty) do
    desc "Logon method for the physical path"
  end

  newproperty(:username, :parent => Puppet::IisProperty) do
    desc "User name that can access the physical path"
  end

  newproperty(:password, :parent => Puppet::IisProperty) do
    desc "Password for the user name"
  end

  newproperty(:allowsubdirconfig, :parent => Puppet::IisProperty) do
    desc "Controls whether IIS will load just the Web.config file in the physical path (false) or also the Web.config files in the sub-directories of the physical path (true)"
  end

  autorequire(:iis_site) do
    resource[:name].split('/')[0]
  end

  autorequire(:iis_app) do
    resource[:iis_app]
  end

  # validate do
  #   iis_app = self[:iis_app]
  #   name = self[:name]
  #
  #   raise Puppet::Error, "name should start with '#{iis_app.chomp('/')}'" unless ensure_trailing_slash(name).start_with?(ensure_trailing_slash(iis_app))
  #
  #   iis_app = iis_app.chomp('/')
  #   iis_app += '/' if iis_app.count('/') == 0
  #
  #   name = ensure_trailing_slash(name)
  #
  #   if name.length > ensure_trailing_slash(iis_app).length
  #     name = name.chomp('/')
  #   end
  #
  #   raise Puppet::Error, "iis_vdir name should be '#{name}'" unless self[:name] == name
  #   raise Puppet::Error, "iis_vdir attribute iis_app should be set to '#{iis_app}'" unless self[:iis_app] == iis_app
  # end
  #
  # def ensure_trailing_slash(value)
  #   (value.end_with?('/')) ? value : (value + '/')
  # end
end
