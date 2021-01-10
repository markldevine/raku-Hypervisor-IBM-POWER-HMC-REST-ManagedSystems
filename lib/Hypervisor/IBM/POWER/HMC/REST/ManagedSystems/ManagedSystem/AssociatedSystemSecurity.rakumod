need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemSecurity:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         $.VirtualTrustedPlatformModuleKeyLength                     is conditional-initialization-attribute;
has     Str                                         $.VirtualTrustedPlatformModuleKeyStatus                     is conditional-initialization-attribute;
has     Str                                         $.VirtualTrustedPlatformModuleVersion                       is conditional-initialization-attribute;
has     Str                                         $.MaximumSupportedVirtualTrustedPlatformModulePartitions    is conditional-initialization-attribute;
has     Str                                         $.AvailableVirtualTrustedPlatformModulePartitions           is conditional-initialization-attribute;

method  xml-name-exceptions () { return set <Metadata>; }

submethod TWEAK {
    self.config.diag.post:      self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_SUBMETHOD>;
    my $proceed-with-name-check = False;
    my $proceed-with-analyze    = False;
    $lock.protect({
        if !$analyzed           { $proceed-with-analyze    = True; $analyzed      = True; }
        if !$names-checked      { $proceed-with-name-check = True; $names-checked = True; }
    });
    self.etl-node-name-check    if $proceed-with-name-check;
    self.init;
    self.analyze                if $proceed-with-analyze;
    self;
}

method init () {
    return self                                                 if $!initialized;
    self.config.diag.post:                                      self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    $!VirtualTrustedPlatformModuleKeyLength                     = self.etl-text(:TAG<VirtualTrustedPlatformModuleKeyLength>,                    :$!xml) if self.attribute-is-accessed(self.^name, 'VirtualTrustedPlatformModuleKeyLength');
    $!VirtualTrustedPlatformModuleKeyStatus                     = self.etl-text(:TAG<VirtualTrustedPlatformModuleKeyStatus>,                    :$!xml) if self.attribute-is-accessed(self.^name, 'VirtualTrustedPlatformModuleKeyStatus');
    $!VirtualTrustedPlatformModuleVersion                       = self.etl-text(:TAG<VirtualTrustedPlatformModuleVersion>,                      :$!xml) if self.attribute-is-accessed(self.^name, 'VirtualTrustedPlatformModuleVersion');
    $!MaximumSupportedVirtualTrustedPlatformModulePartitions    = self.etl-text(:TAG<MaximumSupportedVirtualTrustedPlatformModulePartitions>,   :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumSupportedVirtualTrustedPlatformModulePartitions');
    $!AvailableVirtualTrustedPlatformModulePartitions           = self.etl-text(:TAG<AvailableVirtualTrustedPlatformModulePartitions>,          :$!xml) if self.attribute-is-accessed(self.^name, 'AvailableVirtualTrustedPlatformModulePartitions');
    $!xml                                                       = Nil;
    $!initialized                                               = True;
    self;
}

=finish
