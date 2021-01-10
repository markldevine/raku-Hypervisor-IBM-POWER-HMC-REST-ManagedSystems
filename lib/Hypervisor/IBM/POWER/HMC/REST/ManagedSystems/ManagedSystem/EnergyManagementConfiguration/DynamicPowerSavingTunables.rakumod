need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::EnergyManagementConfiguration::DynamicPowerSavingTunables:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         $.UtilizationThresholdForIncreasingFrequency                    is conditional-initialization-attribute;
has     Str                                         $.UtilizationThresholdForDecreasingFrequency                    is conditional-initialization-attribute;
has     Str                                         $.SamplesForComputingUtilzationStatistics                       is conditional-initialization-attribute;
has     Str                                         $.StepSizeForGoingUpInFrequency                                 is conditional-initialization-attribute;
has     Str                                         $.StepSizeForGoingDownInFrequency                               is conditional-initialization-attribute;
has     Str                                         $.DeltaPercentageForDeterminingActiveCores                      is conditional-initialization-attribute;
has     Str                                         $.UtilizationThresholdToDetermineActiveCoresWithSlack           is conditional-initialization-attribute;
has     Str                                         $.CoreFrequencyDeltaState                                       is conditional-initialization-attribute;
has     Str                                         $.CoreMaximumDeltaFrequency                                     is conditional-initialization-attribute;
has     Str                                         $.MinimumUtilizationThresholdForIncreasingFrequency             is conditional-initialization-attribute;
has     Str                                         $.MinimumUtilizationThresholdForDecreasingFrequency             is conditional-initialization-attribute;
has     Str                                         $.MinimumSamplesForComputingUtilzationStatistics                is conditional-initialization-attribute;
has     Str                                         $.MinimumStepSizeForGoingUpInFrequency                          is conditional-initialization-attribute;
has     Str                                         $.MinimumStepSizeForGoingDownInFrequency                        is conditional-initialization-attribute;
has     Str                                         $.MinimumDeltaPercentageForDeterminingActiveCores               is conditional-initialization-attribute;
has     Str                                         $.MinimumUtilizationThresholdToDetermineActiveCoresWithSlack    is conditional-initialization-attribute;
has     Str                                         $.MinimumCoreMaximumDeltaFrequency                              is conditional-initialization-attribute;
has     Str                                         $.MaximumUtilizationThresholdForIncreasingFrequency             is conditional-initialization-attribute;
has     Str                                         $.MaximumUtilizationThresholdForDecreasingFrequency             is conditional-initialization-attribute;
has     Str                                         $.MaximumSamplesForComputingUtilzationStatistics                is conditional-initialization-attribute;
has     Str                                         $.MaximumStepSizeForGoingUpInFrequency                          is conditional-initialization-attribute;
has     Str                                         $.MaximumStepSizeForGoingDownInFrequency                        is conditional-initialization-attribute;
has     Str                                         $.MaximumDeltaPercentageForDeterminingActiveCores               is conditional-initialization-attribute;
has     Str                                         $.MaximumUtilizationThresholdToDetermineActiveCoresWithSlack    is conditional-initialization-attribute;
has     Str                                         $.MaximumCoreMaximumDeltaFrequency                              is conditional-initialization-attribute;

method xml-name-exceptions () { return set <Metadata>; }

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
    $!UtilizationThresholdForIncreasingFrequency                    = self.etl-text(:TAG<UtilizationThresholdForIncreasingFrequency>,                   :$!xml) if self.attribute-is-accessed(self.^name, 'UtilizationThresholdForIncreasingFrequency');
    $!UtilizationThresholdForDecreasingFrequency                    = self.etl-text(:TAG<UtilizationThresholdForDecreasingFrequency>,                   :$!xml) if self.attribute-is-accessed(self.^name, 'UtilizationThresholdForDecreasingFrequency');
    $!SamplesForComputingUtilzationStatistics                       = self.etl-text(:TAG<SamplesForComputingUtilzationStatistics>,                      :$!xml) if self.attribute-is-accessed(self.^name, 'SamplesForComputingUtilzationStatistics');
    $!StepSizeForGoingUpInFrequency                                 = self.etl-text(:TAG<StepSizeForGoingUpInFrequency>,                                :$!xml) if self.attribute-is-accessed(self.^name, 'StepSizeForGoingUpInFrequency');
    $!StepSizeForGoingDownInFrequency                               = self.etl-text(:TAG<StepSizeForGoingDownInFrequency>,                              :$!xml) if self.attribute-is-accessed(self.^name, 'StepSizeForGoingDownInFrequency');
    $!DeltaPercentageForDeterminingActiveCores                      = self.etl-text(:TAG<DeltaPercentageForDeterminingActiveCores>,                     :$!xml) if self.attribute-is-accessed(self.^name, 'DeltaPercentageForDeterminingActiveCores');
    $!UtilizationThresholdToDetermineActiveCoresWithSlack           = self.etl-text(:TAG<UtilizationThresholdToDetermineActiveCoresWithSlack>,          :$!xml) if self.attribute-is-accessed(self.^name, 'UtilizationThresholdToDetermineActiveCoresWithSlack');
    $!CoreFrequencyDeltaState                                       = self.etl-text(:TAG<CoreFrequencyDeltaState>,                                      :$!xml) if self.attribute-is-accessed(self.^name, 'CoreFrequencyDeltaState');
    $!CoreMaximumDeltaFrequency                                     = self.etl-text(:TAG<CoreMaximumDeltaFrequency>,                                    :$!xml) if self.attribute-is-accessed(self.^name, 'CoreMaximumDeltaFrequency');
    $!MinimumUtilizationThresholdForIncreasingFrequency             = self.etl-text(:TAG<MinimumUtilizationThresholdForIncreasingFrequency>,            :$!xml) if self.attribute-is-accessed(self.^name, 'MinimumUtilizationThresholdForIncreasingFrequency');
    $!MinimumUtilizationThresholdForDecreasingFrequency             = self.etl-text(:TAG<MinimumUtilizationThresholdForDecreasingFrequency>,            :$!xml) if self.attribute-is-accessed(self.^name, 'MinimumUtilizationThresholdForDecreasingFrequency');
    $!MinimumSamplesForComputingUtilzationStatistics                = self.etl-text(:TAG<MinimumSamplesForComputingUtilzationStatistics>,               :$!xml) if self.attribute-is-accessed(self.^name, 'MinimumSamplesForComputingUtilzationStatistics');
    $!MinimumStepSizeForGoingUpInFrequency                          = self.etl-text(:TAG<MinimumStepSizeForGoingUpInFrequency>,                         :$!xml) if self.attribute-is-accessed(self.^name, 'MinimumStepSizeForGoingUpInFrequency');
    $!MinimumStepSizeForGoingDownInFrequency                        = self.etl-text(:TAG<MinimumStepSizeForGoingDownInFrequency>,                       :$!xml) if self.attribute-is-accessed(self.^name, 'MinimumStepSizeForGoingDownInFrequency');
    $!MinimumDeltaPercentageForDeterminingActiveCores               = self.etl-text(:TAG<MinimumDeltaPercentageForDeterminingActiveCores>,              :$!xml) if self.attribute-is-accessed(self.^name, 'MinimumDeltaPercentageForDeterminingActiveCores');
    $!MinimumUtilizationThresholdToDetermineActiveCoresWithSlack    = self.etl-text(:TAG<MinimumUtilizationThresholdToDetermineActiveCoresWithSlack>,   :$!xml) if self.attribute-is-accessed(self.^name, 'MinimumUtilizationThresholdToDetermineActiveCoresWithSlack');
    $!MinimumCoreMaximumDeltaFrequency                              = self.etl-text(:TAG<MinimumCoreMaximumDeltaFrequency>,                             :$!xml) if self.attribute-is-accessed(self.^name, 'MinimumCoreMaximumDeltaFrequency');
    $!MaximumUtilizationThresholdForIncreasingFrequency             = self.etl-text(:TAG<MaximumUtilizationThresholdForIncreasingFrequency>,            :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumUtilizationThresholdForIncreasingFrequency');
    $!MaximumUtilizationThresholdForDecreasingFrequency             = self.etl-text(:TAG<MaximumUtilizationThresholdForDecreasingFrequency>,            :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumUtilizationThresholdForDecreasingFrequency');
    $!MaximumSamplesForComputingUtilzationStatistics                = self.etl-text(:TAG<MaximumSamplesForComputingUtilzationStatistics>,               :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumSamplesForComputingUtilzationStatistics');
    $!MaximumStepSizeForGoingUpInFrequency                          = self.etl-text(:TAG<MaximumStepSizeForGoingUpInFrequency>,                         :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumStepSizeForGoingUpInFrequency');
    $!MaximumStepSizeForGoingDownInFrequency                        = self.etl-text(:TAG<MaximumStepSizeForGoingDownInFrequency>,                       :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumStepSizeForGoingDownInFrequency');
    $!MaximumDeltaPercentageForDeterminingActiveCores               = self.etl-text(:TAG<MaximumDeltaPercentageForDeterminingActiveCores>,              :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumDeltaPercentageForDeterminingActiveCores');
    $!MaximumUtilizationThresholdToDetermineActiveCoresWithSlack    = self.etl-text(:TAG<MaximumUtilizationThresholdToDetermineActiveCoresWithSlack>,   :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumUtilizationThresholdToDetermineActiveCoresWithSlack');
    $!MaximumCoreMaximumDeltaFrequency                              = self.etl-text(:TAG<MaximumCoreMaximumDeltaFrequency>,                             :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumCoreMaximumDeltaFrequency');
    $!xml                                                           = Nil;
    $!initialized                                                   = True;
    self;
}

=finish
