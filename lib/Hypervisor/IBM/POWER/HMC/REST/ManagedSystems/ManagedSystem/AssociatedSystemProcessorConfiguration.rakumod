need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
use     URI;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemProcessorConfiguration:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         $.ConfigurableSystemProcessorUnits                              is conditional-initialization-attribute;
has     Str                                         $.CurrentAvailableSystemProcessorUnits                          is conditional-initialization-attribute;
has     Str                                         $.CurrentMaximumProcessorsPerAIXOrLinuxPartition                is conditional-initialization-attribute;
has     Str                                         $.CurrentMaximumProcessorsPerIBMiPartition                      is conditional-initialization-attribute;
has     Str                                         $.CurrentMaximumAllowedProcessorsPerPartition                   is conditional-initialization-attribute;
has     Str                                         $.CurrentMaximumProcessorsPerVirtualIOServerPartition           is conditional-initialization-attribute;
has     Str                                         $.CurrentMaximumVirtualProcessorsPerAIXOrLinuxPartition         is conditional-initialization-attribute;
has     Str                                         $.CurrentMaximumVirtualProcessorsPerIBMiPartition               is conditional-initialization-attribute;
has     Str                                         $.CurrentMaximumVirtualProcessorsPerVirtualIOServerPartition    is conditional-initialization-attribute;
has     Str                                         $.DeconfiguredSystemProcessorUnits                              is conditional-initialization-attribute;
has     Str                                         $.InstalledSystemProcessorUnits                                 is conditional-initialization-attribute;
has     Str                                         $.MaximumProcessorUnitsPerIBMiPartition                         is conditional-initialization-attribute;
has     Str                                         $.MaximumAllowedVirtualProcessorsPerPartition                   is conditional-initialization-attribute;
has     Str                                         $.MinimumProcessorUnitsPerVirtualProcessor                      is conditional-initialization-attribute;
has     Str                                         $.NumberOfAllOSProcessorUnits                                   is conditional-initialization-attribute;
has     Str                                         $.NumberOfLinuxOnlyProcessorUnits                               is conditional-initialization-attribute;
has     Str                                         $.NumberOfLinuxOrVIOSOnlyProcessorUnits                         is conditional-initialization-attribute;
has     Str                                         $.NumberOfVirtualIOServerProcessorUnits                         is conditional-initialization-attribute;
has     Str                                         $.PendingAvailableSystemProcessorUnits                          is conditional-initialization-attribute;
has     Str                                         $.SharedProcessorPoolCount                                      is conditional-initialization-attribute;
has     Str                                         @.SupportedPartitionProcessorCompatibilityModes                 is conditional-initialization-attribute;
has     Str                                         $.TemporaryProcessorUnitsForLogicalPartitionMobilityInUse       is conditional-initialization-attribute;
has     URI                                         @.SharedProcessorPool                                           is conditional-initialization-attribute;
has     Str                                         $.PermanentSystemProcessors                                     is conditional-initialization-attribute;

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
    return self             if $!initialized;
    self.config.diag.post:                                          self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    $!ConfigurableSystemProcessorUnits                              = self.etl-text(:TAG<ConfigurableSystemProcessorUnits>,                             :$!xml)     if self.attribute-is-accessed(self.^name, 'ConfigurableSystemProcessorUnits');
    $!CurrentAvailableSystemProcessorUnits                          = self.etl-text(:TAG<CurrentAvailableSystemProcessorUnits>,                         :$!xml)     if self.attribute-is-accessed(self.^name, 'CurrentAvailableSystemProcessorUnits');
    $!CurrentMaximumProcessorsPerAIXOrLinuxPartition                = self.etl-text(:TAG<CurrentMaximumProcessorsPerAIXOrLinuxPartition>,               :$!xml)     if self.attribute-is-accessed(self.^name, 'CurrentMaximumProcessorsPerAIXOrLinuxPartition');
    $!CurrentMaximumProcessorsPerIBMiPartition                      = self.etl-text(:TAG<CurrentMaximumProcessorsPerIBMiPartition>,                     :$!xml)     if self.attribute-is-accessed(self.^name, 'CurrentMaximumProcessorsPerIBMiPartition');
    $!CurrentMaximumAllowedProcessorsPerPartition                   = self.etl-text(:TAG<CurrentMaximumAllowedProcessorsPerPartition>,                  :$!xml)     if self.attribute-is-accessed(self.^name, 'CurrentMaximumAllowedProcessorsPerPartition');
    $!CurrentMaximumProcessorsPerVirtualIOServerPartition           = self.etl-text(:TAG<CurrentMaximumProcessorsPerVirtualIOServerPartition>,          :$!xml)     if self.attribute-is-accessed(self.^name, 'CurrentMaximumProcessorsPerVirtualIOServerPartition');
    $!CurrentMaximumVirtualProcessorsPerAIXOrLinuxPartition         = self.etl-text(:TAG<CurrentMaximumVirtualProcessorsPerAIXOrLinuxPartition>,        :$!xml)     if self.attribute-is-accessed(self.^name, 'CurrentMaximumVirtualProcessorsPerAIXOrLinuxPartition');
    $!CurrentMaximumVirtualProcessorsPerIBMiPartition               = self.etl-text(:TAG<CurrentMaximumVirtualProcessorsPerIBMiPartition>,              :$!xml)     if self.attribute-is-accessed(self.^name, 'CurrentMaximumVirtualProcessorsPerIBMiPartition');
    $!CurrentMaximumVirtualProcessorsPerVirtualIOServerPartition    = self.etl-text(:TAG<CurrentMaximumVirtualProcessorsPerVirtualIOServerPartition>,   :$!xml)     if self.attribute-is-accessed(self.^name, 'CurrentMaximumVirtualProcessorsPerVirtualIOServerPartition');
    $!DeconfiguredSystemProcessorUnits                              = self.etl-text(:TAG<DeconfiguredSystemProcessorUnits>,                             :$!xml)     if self.attribute-is-accessed(self.^name, 'DeconfiguredSystemProcessorUnits');
    $!InstalledSystemProcessorUnits                                 = self.etl-text(:TAG<InstalledSystemProcessorUnits>,                                :$!xml)     if self.attribute-is-accessed(self.^name, 'InstalledSystemProcessorUnits');
    $!MaximumProcessorUnitsPerIBMiPartition                         = self.etl-text(:TAG<MaximumProcessorUnitsPerIBMiPartition>,                        :$!xml)     if self.attribute-is-accessed(self.^name, 'MaximumProcessorUnitsPerIBMiPartition');
    $!MaximumAllowedVirtualProcessorsPerPartition                   = self.etl-text(:TAG<MaximumAllowedVirtualProcessorsPerPartition>,                  :$!xml)     if self.attribute-is-accessed(self.^name, 'MaximumAllowedVirtualProcessorsPerPartition');
    $!MinimumProcessorUnitsPerVirtualProcessor                      = self.etl-text(:TAG<MinimumProcessorUnitsPerVirtualProcessor>,                     :$!xml)     if self.attribute-is-accessed(self.^name, 'MinimumProcessorUnitsPerVirtualProcessor');
    $!NumberOfAllOSProcessorUnits                                   = self.etl-text(:TAG<NumberOfAllOSProcessorUnits>,                                  :$!xml)     if self.attribute-is-accessed(self.^name, 'NumberOfAllOSProcessorUnits');
    $!NumberOfLinuxOnlyProcessorUnits                               = self.etl-text(:TAG<NumberOfLinuxOnlyProcessorUnits>,                              :$!xml)     if self.attribute-is-accessed(self.^name, 'NumberOfLinuxOnlyProcessorUnits');
    $!NumberOfLinuxOrVIOSOnlyProcessorUnits                         = self.etl-text(:TAG<NumberOfLinuxOrVIOSOnlyProcessorUnits>,                        :$!xml)     if self.attribute-is-accessed(self.^name, 'NumberOfLinuxOrVIOSOnlyProcessorUnits');
    $!NumberOfVirtualIOServerProcessorUnits                         = self.etl-text(:TAG<NumberOfVirtualIOServerProcessorUnits>,                        :$!xml)     if self.attribute-is-accessed(self.^name, 'NumberOfVirtualIOServerProcessorUnits');
    $!PendingAvailableSystemProcessorUnits                          = self.etl-text(:TAG<PendingAvailableSystemProcessorUnits>,                         :$!xml)     if self.attribute-is-accessed(self.^name, 'PendingAvailableSystemProcessorUnits');
    $!SharedProcessorPoolCount                                      = self.etl-text(:TAG<SharedProcessorPoolCount>,                                     :$!xml)     if self.attribute-is-accessed(self.^name, 'SharedProcessorPoolCount');
    @!SupportedPartitionProcessorCompatibilityModes                 = self.etl-texts(:TAG<SupportedPartitionProcessorCompatibilityModes>,               :$!xml)     if self.attribute-is-accessed(self.^name, 'SupportedPartitionProcessorCompatibilityModes');
    $!TemporaryProcessorUnitsForLogicalPartitionMobilityInUse       = self.etl-text(:TAG<TemporaryProcessorUnitsForLogicalPartitionMobilityInUse>,      :$!xml)     if self.attribute-is-accessed(self.^name, 'TemporaryProcessorUnitsForLogicalPartitionMobilityInUse');
    @!SharedProcessorPool                                           = self.etl-links-URIs(:xml(self.etl-branch(:TAG<SharedProcessorPool>,               :$!xml)))   if self.attribute-is-accessed(self.^name, 'SharedProcessorPool');
    $!PermanentSystemProcessors                                     = self.etl-text(:TAG<PermanentSystemProcessors>,                                    :$!xml)     if self.attribute-is-accessed(self.^name, 'PermanentSystemProcessors');
    $!xml                                                           = Nil;
    $!initialized                                                   = True;
    self;
}

=finish
