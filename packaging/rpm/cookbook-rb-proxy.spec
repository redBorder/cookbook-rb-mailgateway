Name: cookbook-rb-mailgateway
Version: %{__version}
Release: %{__release}%{?dist}
BuildArch: noarch
Summary: redborder mailgateway cookbook to install and configure the redborder environment

License: AGPL 3.0
URL: https://github.com/redBorder/cookbook-rb-mailgateway
Source0: %{name}-%{version}.tar.gz

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/var/chef/cookbooks/rb-mailgateway
cp -f -r  resources/* %{buildroot}/var/chef/cookbooks/rb-mailgateway/
chmod -R 0755 %{buildroot}/var/chef/cookbooks/rb-mailgateway
install -D -m 0644 README.md %{buildroot}/var/chef/cookbooks/rb-mailgateway/README.md

%pre
if [ -d /var/chef/cookbooks/rb-mailgateway ]; then
    rm -rf /var/chef/cookbooks/rb-mailgateway
fi

%post
case "$1" in
  1)
    # This is an initial install.
    :
  ;;
  2)
    # This is an upgrade.
    su - -s /bin/bash -c 'source /etc/profile && rvm gemset use default && env knife cookbook upload rb-mailgateway'
  ;;
esac

%postun
# Deletes directory when uninstall the package
if [ "$1" = 0 ] && [ -d /var/chef/cookbooks/rb-mailgateway ]; then
  rm -rf /var/chef/cookbooks/rb-mailgateway
fi

%files
%defattr(0644,root,root)
%attr(0755,root,root)
/var/chef/cookbooks/rb-mailgateway
%defattr(0644,root,root)
/var/chef/cookbooks/rb-mailgateway/README.md

%doc

%changelog
Mon Feb 23 2026 Vicente Mesa <vimesa@redborder.com>
- Initial release of mailgateway
