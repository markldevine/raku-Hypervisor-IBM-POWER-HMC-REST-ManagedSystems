need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::EnergyManagementConfiguration::IdlePowerSavingTunables:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         $.DelayTimeToEnterIdlePower                     is conditional-initialization-attribute;
has     Str                                         $.DelayTimeToExitIdlePower                      is conditional-initialization-attribute;
has     Str                                         $.UtilizationThresholdToEnterIdlePower          is conditional-initialization-attribute;
has     Str                                         $.UtilizationThresholdToExitIdlePower           is conditional-initialization-attribute;
has     Str                                         $.MinimumDelayTimeToEnterIdlePower              is conditional-initialization-attribute;
has     Str                                         $.MinimumDelayTimeToExitIdlePower               is conditional-initialization-attribute;
has     Str                                         $.MinimumUtilizationThresholdToEnterIdlePower   is conditional-initialization-attribute;
has     Str                                         $.MinimumUtilizationThresholdToExitIdlePower    is conditional-initialization-attribute;
has     Str                                         $.MaximumDelayTimeToEnterIdlePower              is conditional-initialization-attribute;
has     Str                                         $.MaximumDelayTimeToExitIdlePower               is conditional-initialization-attribute;
has     Str                                         $.MaximumUtilizationThresholdToEnterIdlePower   is conditional-initialization-attribute;
has     Str                                         $.MaximumUtilizationThresholdToExitIdlePower    is conditional-initialization-attribute;

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
    return self                                     if $!initialized;
    self.config.diag.post:                          self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    $!DelayTimeToEnterIdlePower                     = self.etl-text(:TAG<DelayTimeToEnterIdlePower>,                    :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'DelayTimeToEnterIdlePower');
    $!DelayTimeToExitIdlePower                      = self.etl-text(:TAG<DelayTimeToExitIdlePower>,                     :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'DelayTimeToExitIdlePower');
    $!UtilizationThresholdToEnterIdlePower          = self.etl-text(:TAG<UtilizationThresholdToEnterIdlePower>,         :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'UtilizationThresholdToEnterIdlePower');
    $!UtilizationThresholdToExitIdlePower           = self.etl-text(:TAG<UtilizationThresholdToExitIdlePower>,          :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'UtilizationThresholdToExitIdlePower');
    $!MinimumDelayTimeToEnterIdlePower              = self.etl-text(:TAG<MinimumDelayTimeToEnterIdlePower>,             :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'MinimumDelayTimeToEnterIdlePower');
    $!MinimumDelayTimeToExitIdlePower               = self.etl-text(:TAG<MinimumDelayTimeToExitIdlePower>,              :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'MinimumDelayTimeToExitIdlePower');
    $!MinimumUtilizationThresholdToEnterIdlePower   = self.etl-text(:TAG<MinimumUtilizationThresholdToEnterIdlePower>,  :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'MinimumUtilizationThresholdToEnterIdlePower');
    $!MinimumUtilizationThresholdToExitIdlePower    = self.etl-text(:TAG<MinimumUtilizationThresholdToExitIdlePower>,   :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'MinimumUtilizationThresholdToExitIdlePower');
    $!MaximumDelayTimeToEnterIdlePower              = self.etl-text(:TAG<MaximumDelayTimeToEnterIdlePower>,             :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'MaximumDelayTimeToEnterIdlePower');
    $!MaximumDelayTimeToExitIdlePower               = self.etl-text(:TAG<MaximumDelayTimeToExitIdlePower>,              :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'MaximumDelayTimeToExitIdlePower');
    $!MaximumUtilizationThresholdToEnterIdlePower   = self.etl-text(:TAG<MaximumUtilizationThresholdToEnterIdlePower>,  :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'MaximumUtilizationThresholdToEnterIdlePower');
    $!MaximumUtilizationThresholdToExitIdlePower    = self.etl-text(:TAG<MaximumUtilizationThresholdToExitIdlePower>,   :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'MaximumUtilizationThresholdToExitIdlePower');
    $!xml                                           = Nil;
    $!initialized                                   = True;
    self;
}

=finish
