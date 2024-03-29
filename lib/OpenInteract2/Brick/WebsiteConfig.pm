package OpenInteract2::Brick::WebsiteConfig;

use strict;
use base qw( OpenInteract2::Brick );
use OpenInteract2::Exception;

my %INLINED_SUBS = (
    'bootstrap.ini' => 'BOOTSTRAPINI',
    'action_override.ini' => 'ACTION_OVERRIDEINI',
    'spops_override.ini' => 'SPOPS_OVERRIDEINI',
    'server.ini' => 'SERVERINI',
    'log4perl.conf' => 'LOG4PERLCONF',
    'observer.ini' => 'OBSERVERINI',
);

sub get_name {
    return 'website_config';
}

sub get_resources {
    return (
        'bootstrap.ini' => [ 'conf bootstrap.ini', 'yes' ],
        'action_override.ini' => [ 'conf sample-action_override.ini', 'yes' ],
        'spops_override.ini' => [ 'conf sample-spops_override.ini', 'yes' ],
        'server.ini' => [ 'conf server.ini', 'yes' ],
        'log4perl.conf' => [ 'conf log4perl.conf', 'yes' ],
        'observer.ini' => [ 'conf observer.ini', 'yes' ],
    );
}

sub load {
    my ( $self, $resource_name ) = @_;
    my $inline_sub_name = $INLINED_SUBS{ $resource_name };
    unless ( $inline_sub_name ) {
        OpenInteract2::Exception->throw(
            "Resource name '$resource_name' not found ",
            "in ", ref( $self ), "; cannot load content." );
    }
    return $self->$inline_sub_name();
}

OpenInteract2::Brick->register_factory_type( get_name() => __PACKAGE__ );

=pod

=head1 NAME

OpenInteract2::Brick::WebsiteConfig - Various non-server-specific configuration files for OI2 website

=head1 SYNOPSIS

  oi2_manage create_website --website_dir=/path/to/site

=head1 DESCRIPTION

This class holds various configuration files for running the OI2 website.

These resources are associated with OpenInteract2 version 1.99_06.

=head2 Resources

You can grab resources individually using the names below and
C<load_resource()> and C<copy_resources_to()>, or you can copy all the
resources at once using C<copy_all_resources_to()> -- see
L<OpenInteract2::Brick> for details.

=over 4


=item B<bootstrap.ini>

=item B<action_override.ini>

=item B<spops_override.ini>

=item B<server.ini>

=item B<log4perl.conf>

=item B<observer.ini>


=back

=head1 COPYRIGHT

Copyright (c) 2005 Chris Winters. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS


Chris Winters E<lt>chris@cwinters.comE<gt>


=cut


sub BOOTSTRAPINI {
    return <<'SOMELONGSTRING';
# This configuration bootstraps the server into existence
[bootstrap]
website_dir  = [% website_dir %]
config_dir   = conf
config_file  = server.ini
config_type  = ini
config_class = OpenInteract2::Config::IniFile
package_dir  = pkg
temp_lib_dir = tmplib

SOMELONGSTRING
}

sub ACTION_OVERRIDEINI {
    return <<'SOMELONGSTRING';
# $Id: action_override.ini,v 1.1 2005/01/28 15:37:10 lachoy Exp $

# Sample action override rules. If you decide to use override rules,
# save them to '$WEBSITE_DIR/conf/action_override.ini'.

#
# modify the security for 'news' action

[news.security.DEFAULT]
action  = replace
value   = NONE

#
# change a template to use for the 'search' task

[news.template_source.search]
action  = replace
value   = news::my_search_results

SOMELONGSTRING
}

sub SPOPS_OVERRIDEINI {
    return <<'SOMELONGSTRING';
# $Id: spops_override.ini,v 1.1 2005/01/28 15:37:10 lachoy Exp $

# Sample SPOPS override rules. If you decide to use override rules,
# save them to '$WEBSITE_DIR/conf/spops_override.ini'.

#
# New objects will get added to "What's new?"

[news.rules_from]
action  = add
value   = OpenInteract2::WhatsNewTrack
type    = list

#
# New objects will get added to the full-text index

[news.is_searchable]
action  = replace
value   = yes

SOMELONGSTRING
}

sub SERVERINI {
    return <<'SOMELONGSTRING';
# OPENINTERACT 2.x SERVER CONFIGURATION
#  This is the main configuration file for OpenInteract 2.x. All
#  comments can be removed with a one-liner:
#
#    perl -ne 'print unless /^\s*#/' < server.ini > server_new.ini

# Items in this section will be available from the configuration
# object's root, at least for the time being
#
#   promote_oi
#      If set to 'yes' I'll put a 'X-Powered-By' header in all the
#      pages I serve.
#   ConfigurationRevision
#      Used for debugging
#   timezone
#      Set to a timezone that can be used as the 'time_zone' parameter
#      in a DateTime object (which in turn should be able to be used
#      as the 'name' parameter to the DateTime::TimeZone->new()
#      constructor.

[Global]
promote_oi            = yes
ConfigurationRevision = $Revision: 1.52 $
timezone              = America/New_York

#  General information about the context of your server

#   deployed_under
#      A top-level URL that the server runs under. By default this is
#      blank so the server expects URLs at the top level. If you set
#      this to '/MyOI' for instance, then '/User/search/' is
#      equivalent to '/MyOI/User/search/'
#   deployed_under_image
#      Top-level URL that images are deployed under. If left blank
#      images will be at '/images/...'
#   deployed_under_static
#      Top-level URL that static files (like PDFs, RSS, etc.) are
#      deployed under. There's no default for this, so if left as is
#      any URLs passed to OI2::URL will be unmodified.

[context_info]
deployed_under        = 
deployed_under_image  =
deployed_under_static = 

#
# Information about how to send email and some system email addresses

[mail]
smtp_host     = 127.0.0.1
admin_email   = admin@mycompany.com
content_email = content@mycompany.com


#
# Define some system-wide datasources. (See also:
# 'session_info.datasource')
#   spops
#     Default datasource for SPOPS objects.
#   system
#     Default datasource for system tables. Some of these are not
#     SPOPS objects.
#   ldap
#     Default datasource for LDAP objects.
#   manager
#     Class of the datasource manager

[datasource_config]
spops         = main
system        = main
ldap          = main_ldap
manager       = OpenInteract2::DatasourceManager

# 
# Add datasource type mappings here. We may allow default driver
# settings here also - 'long_read_len', etc., but for now KISS is the
# rule of the day.

[datasource_type DBI]
connection_manager = OpenInteract2::Datasource::DBI
spops_config       = OpenInteract2::SPOPS::DBI

[datasource_type LDAP]
connection_manager = OpenInteract2::Datasource::LDAP
spops_config       = OpenInteract2::SPOPS::LDAP

#
# Enter your database connection parameters in the 'main' entry -- see
# 'OpenInteract2::Datasource::DBI' for more information about
# them). Briefly:
#
#   type
#     DBI (this should not change)
#   dbi_type
#     type of database (MySQL, Pg, Oracle, MSSQL, Sybase, ASAny, SQLite)
#   dsn
#     last part of the DBI DSN
#   username  
#     who do we login as?
#   password
#     what password do we login with?

[datasource main]
type     = DBI
dbi_type =
dsn      =
username =
password =

#
# Enter your LDAP connection information if you're using
# LDAP. Briefly:
#
#   host
#     The IP address/hostname with the LDAP server
#   port
#     The port the LDAP server is running on (usually 389)
#   bind_dn
#     The distinguished name of the record to bind as. If left
#     blank you will be doing an anonymous bind and the value for
#     'bind_password' will not be used.
#   bind_password
#     Password to use with 'bind_dn' to bind to the server.
#   base_dn
#     Can be used by modules to determine the Base DN where
#     objects should be stored. This might be something like
#     'dc=MyCompany,dc=com'
#   timeout
#     Value (in seconds) to wait for a timed out connection
#   version
#     LDAP protocol version. Use '3' if you're using SASL
#   sasl
#     Set to a true value to use SASL authentication
#   debug
#     See entry in Net::LDAP->new() for possible values

[datasource main_ldap]
type          = LDAP
spops         = SPOPS::LDAP
host          = 
port          =
bind_dn       =
bind_password =
base_dn       =
timeout       = 120
version       = 2
sasl          = 0
debug         = 0


#
# fulltext.default
#   Decide which indexer to use. The name corresponds # to a
#   configuration section under 'fulltext'. So 'default = DBI' # means
#   to use the implementation in 'fulltext.DBI.class'

[fulltext]
default = DBI

#
# DBI full-text implementation
#   This is the implementation found in the 'full_text' package
#   shipped with OI2. Read more in the implementation class 
#   'OpenInteract2::FullTextSearch::DBI'

[fulltext DBI]
class           = OpenInteract2::FullTextIndexer::DBI
datasource      = main
column_group    = listing
min_word_length = 3
max_word_length = 30
index_table     = full_text_index
class_map_table = full_text_index_class
stem_locale     = en

#
# If you're not using a database-backed session store, just change
# 'class' to the relevant OpenInteract implementation class (e.g.,
# 'OpenInteract2::SessionManager::File' or '::SQLite' and if necessary
# change 'impl_class' to the actual implementation class (e.g.,
# 'Apache::Session::File'); you'll also need to create relevant
# entries in 'session_info.params' below (e.g., 'Directory' and
# 'LockDirectory' for 'Apache::Session::File').
#
# If you are using a database-backed session store, you just need
# to change 'impl_class' to the relevant storage module (e.g.,
# 'Apache::Session::Postgres') You can also change
# 'datasource' to the name of the datasource being used.
#
# Note that you can also set the expiration for the session
# cookie -- if you set it to be 'undef' the cookie will be
# 'short-lived', meaning it will expire when the user shuts
# down the browser. Otherwise, pass something like the
# following: '+3d' (3 days); '+3M' (3 months); '+480s' (480
# seconds); '+15h' (15 hours); '+1y' (1 year)
#
# The setting for 'expires_in' is in minutes. If set to 0 or undefined
# the sessions will never be time-expired.
#
# The 'cache_*' settings determine whether the user, group and theme
# objects should be stored in the session. If set to 0 we fetch this
# information every request. If set to a positive number, we store the
# objects in the session and refresh it every x minutes.

[session_info]
class       = OpenInteract2::SessionManager::File
impl_class  = Apache::Session::File
datasource  = main
expiration  = +3M
expires_in  = 0
cache_user  = 30
cache_group = 30
cache_theme = 30

[session_info params]
Directory     = cache/sessions
LockDirectory = cache/sessions_lock

#
# Unless you're using LDAP for authentication, you probably don't
# want to change these in the beginning. However, you might want
# to change them (particularly the 'theme' value) as your site
# grows.

[default_objects]
superuser        = 1
supergroup       = 1
theme            = 1
public_group     = 2
site_admin_group = 3


#
# Define the box handler and the handler to take care of the
# default system boxes. The 'custom_box_handler' entry is for you
# to fill in if you'd like -- you can add other boxes to every
# page, add them depending on the request type, etc.

[box]
action             = box_display
default_template   = base_box::main_box_shell
default_separator  =
default_method     = 
system_box_handler = OpenInteract2::Action::SystemBoxes
system_box_method  =
custom_box_handler =
custom_box_method  =


#
# Define login information. In the future you'll be able to define
# the object(s) used for logging in and possibly more.
#
# auth_user_class: Define the class used for getting login information
# (username/password), creating a user and checking the password. If
# you have custom login needs to may want to modify this -- see
# OpenInteract2::Auth::User for info.
#
# auth_group_class: Define the class used for getting the groups
# related to a logged-in user. This is rarer to change, but if you'd
# like to see OpenInteract2::Auth::Group for info.
#
# auth_admin_class: Define the class used to see whether a user/group
# combination is an administrator or not. See
# OpenInteract2::Auth::AdminCheck for info.
#
# custom_login_*: Class and method that specify an action that
# executes when a user logs in (Optional)
#
# crypt_password: Set whether you want to store encrypted passwords in
# the database (set by default and recommended). Note that if you're
# using LDAP or some SMB authentication you want to set this to '0'
# since the backend will take care of that for you.
#
# disable_superuser_password_change: If set to a true value you will
# not be able to set the superuser password using the
# 'create_password' management task.
#
# initial_login_expires: amount of time after which a 'cleanup_user'
# task (if run) will delete a user; if you never cleanup orphaned
# logins don't worry about this.
# 
# *_field: These are the fields used to read in the username and
# password from the user and are used in the 'login_box' component
# shipped with OpenInteract and found in the 'base_box' package. Note
# that if 'remember_field' is not defined then we don't display the
# checkbox in the login box.
#
# always_remember: if true then we always remember the login (and
# don't display the checkbox)
#
# required: if set a login is always required; if the user isn't
# logged in she'll be sent to the URL in 'required_url'
#
# required_skip: zero or more regular expressions indicating the areas
# of the site that don't require a login even if 'required' is
# true. (Don't include your deployment path in these if you have one.)

[login]
auth_user_class      = OpenInteract2::Auth::User
auth_group_class     = OpenInteract2::Auth::Group
auth_admin_class     = OpenInteract2::Auth::AdminCheck

custom_login_handler = 
custom_login_method  = 

crypt_password                    = 1
disable_superuser_password_change = 0

initial_login_expires = 24h
login_field           = login_login_name
password_field        = login_password
remember_field        = login_remember
always_remember       = 0
required              = 0
required_url          = /login.html
required_skip         = ^/$
required_skip         = ^/index.html$
required_skip         = ^/Login.*
required_skip         = ^/help.*


# Various language settings

# default_language: default language for this website; this will be
# used for the superuser (when the site is created), users who aren't
# logged in, and users who don't have a language selected
#
# choice_param_name: if a user isn't logged in we check the GET/POST
# parameters to see if a particular language has been chosen for this
# request; this setting names the parameter we check

[language]
default_language         = en
choice_param_name        = oi_language

#
# How to do HTTP redirects
#
# use_meta_redirect: if set to 1 we'll create a redirect using META
# tags (old way)
#
# use_header_redirect: if set to 1 we'll perform a redirect using HTTP
# headers (new way); overrides 'use_header_redirect' if set
#
# show_redirect_message: if using 'use_meta_redirect' controls whether
# we display a message in the page using META tags


[redirect]
use_meta_redirect     = 0
use_header_redirect   = 1
show_redirect_message = 0


# Internal mapping for convenience.

[system_class]
repository       = OpenInteract2::Repository
package          = OpenInteract2::Package
template         = OpenInteract2::SiteTemplate
setup            = OpenInteract2::Setup
ini_reader       = OpenInteract2::Config::Ini

# List your OI2::Request and OI2::Response implementations; these are
# registered at server startup but not included until you request them

[request]
apache     = OpenInteract2::Request::Apache
apache2    = OpenInteract2::Request::Apache2
cgi        = OpenInteract2::Request::CGI
lwp        = OpenInteract2::Request::LWP
standalone = OpenInteract2::Request::Standalone

[response]
apache     = OpenInteract2::Response::Apache
apache2    = OpenInteract2::Response::Apache2
cgi        = OpenInteract2::Response::CGI
lwp        = OpenInteract2::Response::LWP
standalone = OpenInteract2::Response::Standalone


#
# Define what your system uses for certain IDs. Defaults are fine
# for most uses -- the most common need for changing these is
# if you're using LDAP to store user and group objects.
#
# Currently accepted values for *_type: 'int', 'char'
#
# If _type is set to 'char', then _size should be set to the necessary
# width of the field. Default is 25.

[id]
user_type  = int
user_size  = 25
group_type = int
group_size = 25


#
# Directories used by OpenInteract. Only change these if you know what
# you're doing. Note that 'website' is replaced when the server starts
# up, so any value you set there will be overwritten. When this
# configuration file is read all other keys (like $WEBSITE) get
# replaced with the corresponding value under 'dir'. The
# subdirectories are space-separated so we can pass them to File::Spec
# and get a os-specific path.
#
# TODO: Be sure to modify all references from get_dir( 'base' ) to
# {dir}{website}

[dir]
website       = 
html          = $WEBSITE/html
help          = $WEBSITE/html/help
download      = $WEBSITE/html/downloads
error         = $WEBSITE/error
log           = $WEBSITE/logs
config        = $WEBSITE/conf
data          = $WEBSITE/data
mail          = $WEBSITE/mail
msg           = $WEBSITE/msg
overflow      = $WEBSITE/overflow
upload        = $WEBSITE/uploads
template      = $WEBSITE/template
package       = $WEBSITE/pkg

#
# Control OpenInteract caching. If 'use' is set to 'no' the no caching
# will be enabled. The 'class' key controls where the cache is
# stored. Some implementations respect 'max_size' (in bytes). The
# 'cleanup' key controls whether the cache is cleaned out at server
# startup. And the '::File' implementation will use 'directory' (to
# specify where the cache root begins) and 'directory_depth' so that you
# don't put too many files in a single directory.

[cache]
use             = no
use_spops       = no
default_expire  = 600
directory       = [% website_dir %]/cache/content
class           = OpenInteract2::Cache::File
max_size        = 2000000
cleanup         = yes
directory_depth = 3

#
# Define the different content generators (Template Toolkit,
# HTML::Template, SOAP, etc.). Each content generator can have its own
# configuration settings.

#
# Template Toolkit configuration settings
#
# template_ext: Default extension for template files. We also check
# for files with a given name and no extension
#
# cache_size: How many templates TT should cache in memory
#
# cache_size: How long TT should keep cached templates in memory (seconds)
#
# compile_cleanup: If true, will remove all compiled files on server
# restart (production boxes can set this to false so that startup
# costs aren't so heavy)
#
# compile_dir: Directory where compiled files are stored; this is
# resolved at runtime under the website directory.
#
# compile_ext: Extension for compiled TT files. Most people won't (or
# shouldn't) care about this.
#
# custom_init_class: Location of 'custom_template_initialize()' class method
# that's called before the template object is initialized. Here you
# can define a PRE_PROCESS template (for instance, with BLOCKs having
# all your common widgets) or set any of the other configuration
# information specified in 'Template::Manual::Config'
#
# custom_variable_class: Location of 'custom_template_vars()' class
# method that's called before every template is processed. If you have
# common BLOCKs, formatting elements or other items that are not
# full-blown OI components, you can add them to the variables seen by
# every template.

[content_generator TT]
class                 = OpenInteract2::ContentGenerator::TT2Process
template_ext          = tmpl
cache_size            = 100
cache_expire          = 900
compile_cleanup       = 1
compile_dir           = cache/tt
compile_ext           = .ttc
custom_init_class     =
custom_variable_class =

# Sample for Text::Template
#[content_generator TextTemplate]
#class = OpenInteract2::ContentGenerator::TextTemplate

# Sample for HTML::Template
#[content_generator HTMLTemplate]
#class = OpenInteract2::ContentGenerator::HtmlTemplate

#
# Define the main controller; if you create additional
# interfaces for your website(s) (e.g. SOAP) then you
# will need to add entries here

[controller tt-template]
content_generator = TT
class             = OpenInteract2::Controller::MainTemplate

[controller html-template]
content_generator = HTMLTemplate
class             = OpenInteract2::Controller::MainTemplate

[controller text-template]
content_generator = TextTemplate
class             = OpenInteract2::Controller::MainTemplate

[controller raw]
class             = OpenInteract2::Controller::Raw

# The action table defines how OpenInteract responds to URLs; the only
# information we hold here is for default information
# ('action_info.default') -- information that does not need to be
# specified in the individual package's 'conf/action.ini' file; we
# also define how OpenInteract should respond to a null action (under
# 'action_info.none') and how it should respond to an action that is
# not found (under 'action_info.not_found')

[action_info]
none      = page
not_found = page

[action_info default]
controller         = tt-template
content_generator  = TT

[action_types]
template_only = OpenInteract2::Action::TemplateOnly
lookup        = OpenInteract2::Action::LookupEdit

# Define additional observers to SPOPS/action configuration
# initialization. Package authors typically take care of this in the
# package's 'package.conf', but just in case. Use a
# 'class = My::Class' format where 'My::Class' is your observer class.

[config_watcher]

SOMELONGSTRING
}

sub LOG4PERLCONF {
    return <<'SOMELONGSTRING';
########################################
# ROOT CATEGORY

log4perl.logger = FATAL, FileAppender, OIAppender

########################################
# OI2 CATEGORIES

# This is the root OI2 logger. Lowering its level without specifying
# the other OI2 loggers will result in lots of messages.

log4perl.logger.OI2             = INFO
#log4perl.logger.OI2.ACTION     = WARN
#log4perl.logger.OI2.APP        = DEBUG
#log4perl.logger.OI2.AUTH       = DEBUG
#log4perl.logger.OI2.CACHE      = WARN
log4perl.logger.OI2.CONFIG     = WARN
#log4perl.logger.OI2.DS         = WARN
#log4perl.logger.OI2.INITIALIZE = WARN
#log4perl.logger.OI2.REQUEST    = WARN
#log4perl.logger.OI2.RESPONSE   = WARN
#log4perl.logger.OI2.SECURITY   = WARN
#log4perl.logger.OI2.SESSION    = WARN
#log4perl.logger.OI2.SPOPS      = WARN
log4perl.logger.OI2.TEMPLATE   = WARN
# Uncomment this to see message keys in the localized messages
#log4perl.logger.OI2.TRANSLATE  = DEBUG

########################################
# SPOPS CATEGORIES

# Unlike OI2, SPOPS uses its class names as categories; a few of the
# classes you'll probably be interested in are listed

log4perl.logger.SPOPS = WARN
#log4perl.logger.SPOPS.ClassFactory = INFO
#log4perl.logger.SPOPS.DBI = INFO
#log4perl.logger.SPOPS.Export = INFO
#log4perl.logger.SPOPS.Import = INFO
#log4perl.logger.SPOPS.LDAP = INFO
#log4perl.logger.SPOPS.Secure = INFO
#log4perl.logger.SPOPS.SQLInterface = INFO

########################################
# CUSTOM CATEGORIES

# Add your custom categories here...

########################################
# OI2 APPENDERS

# Normal file log
log4perl.appender.FileAppender          = Log::Log4perl::Appender::File
log4perl.appender.FileAppender.filename = [% website_dir %]/logs/oi2.log
log4perl.appender.FileAppender.layout   = Log::Log4perl::Layout::PatternLayout
log4perl.appender.FileAppender.layout.ConversionPattern = %d{HH:mm:ss} %p %c %C (%L) %m %n

# Stores errors to the filesystem for later browsing.

log4perl.appender.OIAppender          = OpenInteract2::Log::OIAppender
log4perl.appender.OIAppender.layout   = Log::Log4perl::Layout::PatternLayout
log4perl.appender.OIAppender.layout.ConversionPattern = %c && %C && %L && %m
log4perl.appender.OIAppender.Threshold = ERROR


SOMELONGSTRING
}

sub OBSERVERINI {
    return <<'SOMELONGSTRING';
# observer.ini: Specify observers that can react to observations
# published by actions or other objects. Filters are the most common
# example of these.
#
# Example, declare observers:
#
# [observer]
# wiki    = OpenInteract2::Filter::WikiFormat
# useperl = OpenInteract2::Observer::UsePerlPost
#
# Example, map observer to action
#
# [map]
# wiki    = page
# useperl = news

# See docs for OpenInteract2::Action under OBSERVABLE ACTIONS for more

SOMELONGSTRING
}

