need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedIPLConfiguration:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;

has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         $.CurrentManufacturingDefaulConfigurationtBootMode  is conditional-initialization-attribute;
has     Str                                         $.CurrentPowerOnSide                                is conditional-initialization-attribute;
has     Str                                         $.CurrentSystemKeylock                              is conditional-initialization-attribute;
has     Str                                         $.MajorBootType                                     is conditional-initialization-attribute;
has     Str                                         $.MinorBootType                                     is conditional-initialization-attribute;
has     Str                                         $.PendingManufacturingDefaulConfigurationtBootMode  is conditional-initialization-attribute;
has     Str                                         $.PendingPowerOnSide                                is conditional-initialization-attribute;
has     Str                                         $.PendingSystemKeylock                              is conditional-initialization-attribute;
has     Str                                         $.PowerOnLogicalPartitionStartPolicy                is conditional-initialization-attribute;
has     Str                                         $.PowerOnOption                                     is conditional-initialization-attribute;
has     Str                                         $.PowerOnSpeed                                      is conditional-initialization-attribute;
has     Str                                         $.PowerOnSpeedOverride                              is conditional-initialization-attribute;
has     Str                                         $.PowerOffWhenLastLogicalPartitionIsShutdown        is conditional-initialization-attribute;
has     Str                                         $.CurrentManufacturingDefaultConfigurationSource    is conditional-initialization-attribute;
has     Str                                         $.PendingManufacturingDefaultConfigurationSource    is conditional-initialization-attribute;
has     Str                                         $.PendingPowerOnLogicalPartitionStartPolicy         is conditional-initialization-attribute;
has     Str                                         $.PowerOnSource                                     is conditional-initialization-attribute;

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
    return self                                         if $!initialized;
    self.config.diag.post:                              self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    $!CurrentManufacturingDefaulConfigurationtBootMode  = self.etl-text(:TAG<CurrentManufacturingDefaulConfigurationtBootMode>, :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentManufacturingDefaulConfigurationtBootMode');
    $!CurrentPowerOnSide                                = self.etl-text(:TAG<CurrentPowerOnSide>,                               :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentPowerOnSide');
    $!CurrentSystemKeylock                              = self.etl-text(:TAG<CurrentSystemKeylock>,                             :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentSystemKeylock');
    $!MajorBootType                                     = self.etl-text(:TAG<MajorBootType>,                                    :$!xml) if self.attribute-is-accessed(self.^name, 'MajorBootType');
    $!MinorBootType                                     = self.etl-text(:TAG<MinorBootType>,                                    :$!xml) if self.attribute-is-accessed(self.^name, 'MinorBootType');
    $!PendingManufacturingDefaulConfigurationtBootMode  = self.etl-text(:TAG<PendingManufacturingDefaulConfigurationtBootMode>, :$!xml) if self.attribute-is-accessed(self.^name, 'PendingManufacturingDefaulConfigurationtBootMode');
    $!PendingPowerOnSide                                = self.etl-text(:TAG<PendingPowerOnSide>,                               :$!xml) if self.attribute-is-accessed(self.^name, 'PendingPowerOnSide');
    $!PendingSystemKeylock                              = self.etl-text(:TAG<PendingSystemKeylock>,                             :$!xml) if self.attribute-is-accessed(self.^name, 'PendingSystemKeylock');
    $!PowerOnLogicalPartitionStartPolicy                = self.etl-text(:TAG<PowerOnLogicalPartitionStartPolicy>,               :$!xml) if self.attribute-is-accessed(self.^name, 'PowerOnLogicalPartitionStartPolicy');
    $!PowerOnOption                                     = self.etl-text(:TAG<PowerOnOption>,                                    :$!xml) if self.attribute-is-accessed(self.^name, 'PowerOnOption');
    $!PowerOnSpeed                                      = self.etl-text(:TAG<PowerOnSpeed>,                                     :$!xml) if self.attribute-is-accessed(self.^name, 'PowerOnSpeed');
    $!PowerOnSpeedOverride                              = self.etl-text(:TAG<PowerOnSpeedOverride>,                             :$!xml) if self.attribute-is-accessed(self.^name, 'PowerOnSpeedOverride');
    $!PowerOffWhenLastLogicalPartitionIsShutdown        = self.etl-text(:TAG<PowerOffWhenLastLogicalPartitionIsShutdown>,       :$!xml) if self.attribute-is-accessed(self.^name, 'PowerOffWhenLastLogicalPartitionIsShutdown');
    $!CurrentManufacturingDefaultConfigurationSource    = self.etl-text(:TAG<CurrentManufacturingDefaultConfigurationSource>,   :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentManufacturingDefaultConfigurationSource');
    $!PendingManufacturingDefaultConfigurationSource    = self.etl-text(:TAG<PendingManufacturingDefaultConfigurationSource>,   :$!xml) if self.attribute-is-accessed(self.^name, 'PendingManufacturingDefaultConfigurationSource');
    $!PendingPowerOnLogicalPartitionStartPolicy         = self.etl-text(:TAG<PendingPowerOnLogicalPartitionStartPolicy>,        :$!xml) if self.attribute-is-accessed(self.^name, 'PendingPowerOnLogicalPartitionStartPolicy');
    $!PowerOnSource                                     = self.etl-text(:TAG<PowerOnSource>,                                    :$!xml) if self.attribute-is-accessed(self.^name, 'PowerOnSource');
    $!xml                                               = Nil;
    $!initialized                                       = True;
    self;
}

=finish
