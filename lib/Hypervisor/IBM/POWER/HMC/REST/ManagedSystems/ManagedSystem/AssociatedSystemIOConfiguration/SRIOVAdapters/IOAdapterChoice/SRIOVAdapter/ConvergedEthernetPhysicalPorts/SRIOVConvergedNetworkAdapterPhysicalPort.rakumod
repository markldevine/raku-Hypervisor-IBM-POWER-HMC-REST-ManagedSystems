need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter::ConvergedEthernetPhysicalPorts::SRIOVConvergedNetworkAdapterPhysicalPort:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         $.ConfiguredConnectionSpeed                         is conditional-initialization-attribute;
has     Str                                         $.ConfiguredMTU                                     is conditional-initialization-attribute;
has     Str                                         @.ConfiguredOptions                                 is conditional-initialization-attribute;
has     Str                                         $.CurrentConnectionSpeed                            is conditional-initialization-attribute;
has     Str                                         @.CurrentOptions                                    is conditional-initialization-attribute;
has     Str                                         $.Label                                             is conditional-initialization-attribute;
has     Str                                         $.LocationCode                                      is conditional-initialization-attribute;
has     Str                                         $.MaximumDiagnosticsLogicalPorts                    is conditional-initialization-attribute;
has     Str                                         $.MaximumPromiscuousLogicalPorts                    is conditional-initialization-attribute;
has     Str                                         $.PhysicalPortID                                    is conditional-initialization-attribute;
has     Str                                         @.PortCapabilities                                  is conditional-initialization-attribute;
has     Str                                         $.PortType                                          is conditional-initialization-attribute;
has     Str                                         $.PortLogicalPortLimit                              is conditional-initialization-attribute;
has     Str                                         $.SubLabel                                          is conditional-initialization-attribute;
has     Str                                         @.SupportedConnectionSpeeds                         is conditional-initialization-attribute;
has     Str                                         @.SupportedMTUs                                     is conditional-initialization-attribute;
has     Str                                         @.SupportedOptions                                  is conditional-initialization-attribute;
has     Str                                         $.SupportedPriorityAccessControlList                is conditional-initialization-attribute;
has     Str                                         $.LinkStatus                                        is conditional-initialization-attribute;
has     Str                                         $.AllocatedCapacity                                 is conditional-initialization-attribute;
has     Str                                         $.ConfiguredMaxEthernetLogicalPorts                 is conditional-initialization-attribute;
has     Str                                         $.ConfiguredEthernetLogicalPorts                    is conditional-initialization-attribute;
has     Str                                         $.MaximumPortVLANID                                 is conditional-initialization-attribute;
has     Str                                         $.MaximumVLANID                                     is conditional-initialization-attribute;
has     Str                                         $.MinimumEthernetCapacityGranularity                is conditional-initialization-attribute;
has     Str                                         $.MinimumPortVLANID                                 is conditional-initialization-attribute;
has     Str                                         $.MinimumVLANID                                     is conditional-initialization-attribute;
has     Str                                         $.MaxSupportedEthernetLogicalPorts                  is conditional-initialization-attribute;
has     Str                                         $.MaximumAllowedEthVLANs                            is conditional-initialization-attribute;
has     Str                                         $.MaximumAllowedEthMACs                             is conditional-initialization-attribute;
has     Str                                         $.ConfiguredMaxFiberChannelOverEthernetLogicalPorts is conditional-initialization-attribute;
has     Str                                         $.DefaultFiberChannelTargetsForBackingDevice        is conditional-initialization-attribute;
has     Str                                         $.DefaultFiberChannelTargetsForNonBackingDevice     is conditional-initialization-attribute;
has     Str                                         $.ConfiguredFiberChannelOverEthernetLogicalPorts    is conditional-initialization-attribute;
has     Str                                         $.FiberChannelTargetsRoundingValue                  is conditional-initialization-attribute;
has     Str                                         $.MaxSupportedFiberChannelOverEthernetLogicalPorts  is conditional-initialization-attribute;
has     Str                                         $.MaximumFiberChannelTargets                        is conditional-initialization-attribute;

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
    $!ConfiguredConnectionSpeed                         = self.etl-text(:TAG<ConfiguredConnectionSpeed>,                            :$!xml)             if self.attribute-is-accessed(self.^name, 'ConfiguredConnectionSpeed');
    $!ConfiguredMTU                                     = self.etl-text(:TAG<ConfiguredMTU>,                                        :$!xml)             if self.attribute-is-accessed(self.^name, 'ConfiguredMTU');
    @!ConfiguredOptions                                 = self.etl-texts(:TAG<ConfiguredOptions>,                                   :$!xml)             if self.attribute-is-accessed(self.^name, 'ConfiguredOptions');
    $!CurrentConnectionSpeed                            = self.etl-text(:TAG<CurrentConnectionSpeed>,                               :$!xml)             if self.attribute-is-accessed(self.^name, 'CurrentConnectionSpeed');
    @!CurrentOptions                                    = self.etl-texts(:TAG<CurrentOptions>,                                      :$!xml)             if self.attribute-is-accessed(self.^name, 'CurrentOptions');
    $!Label                                             = self.etl-text(:TAG<Label>,                                                :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'Label');
    $!LocationCode                                      = self.etl-text(:TAG<LocationCode>,                                         :$!xml)             if self.attribute-is-accessed(self.^name, 'LocationCode');
    $!MaximumDiagnosticsLogicalPorts                    = self.etl-text(:TAG<MaximumDiagnosticsLogicalPorts>,                       :$!xml)             if self.attribute-is-accessed(self.^name, 'MaximumDiagnosticsLogicalPorts');
    $!MaximumPromiscuousLogicalPorts                    = self.etl-text(:TAG<MaximumPromiscuousLogicalPorts>,                       :$!xml)             if self.attribute-is-accessed(self.^name, 'MaximumPromiscuousLogicalPorts');
    $!PhysicalPortID                                    = self.etl-text(:TAG<PhysicalPortID>,                                       :$!xml)             if self.attribute-is-accessed(self.^name, 'PhysicalPortID');
    @!PortCapabilities                                  = self.etl-texts(:TAG<PortCapabilities>,                                    :$!xml)             if self.attribute-is-accessed(self.^name, 'PortCapabilities');
    $!PortType                                          = self.etl-text(:TAG<PortType>,                                             :$!xml)             if self.attribute-is-accessed(self.^name, 'PortType');
    $!PortLogicalPortLimit                              = self.etl-text(:TAG<PortLogicalPortLimit>,                                 :$!xml)             if self.attribute-is-accessed(self.^name, 'PortLogicalPortLimit');
    $!SubLabel                                          = self.etl-text(:TAG<SubLabel>,                                             :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'SubLabel');
    @!SupportedConnectionSpeeds                         = self.etl-texts(:TAG<SupportedConnectionSpeeds>,                           :$!xml)             if self.attribute-is-accessed(self.^name, 'SupportedConnectionSpeeds');
    @!SupportedMTUs                                     = self.etl-texts(:TAG<SupportedMTUs>,                                       :$!xml)             if self.attribute-is-accessed(self.^name, 'SupportedMTUs');
    @!SupportedOptions                                  = self.etl-texts(:TAG<SupportedOptions>,                                    :$!xml)             if self.attribute-is-accessed(self.^name, 'SupportedOptions');
    $!SupportedPriorityAccessControlList                = self.etl-text(:TAG<SupportedPriorityAccessControlList>,                   :$!xml)             if self.attribute-is-accessed(self.^name, 'SupportedPriorityAccessControlList');
    $!LinkStatus                                        = self.etl-text(:TAG<LinkStatus>,                                           :$!xml)             if self.attribute-is-accessed(self.^name, 'LinkStatus');
    $!AllocatedCapacity                                 = self.etl-text(:TAG<AllocatedCapacity>,                                    :$!xml)             if self.attribute-is-accessed(self.^name, 'AllocatedCapacity');
    $!ConfiguredMaxEthernetLogicalPorts                 = self.etl-text(:TAG<ConfiguredMaxEthernetLogicalPorts>,                    :$!xml)             if self.attribute-is-accessed(self.^name, 'ConfiguredMaxEthernetLogicalPorts');
    $!ConfiguredEthernetLogicalPorts                    = self.etl-text(:TAG<ConfiguredEthernetLogicalPorts>,                       :$!xml)             if self.attribute-is-accessed(self.^name, 'ConfiguredEthernetLogicalPorts');
    $!MaximumPortVLANID                                 = self.etl-text(:TAG<MaximumPortVLANID>,                                    :$!xml)             if self.attribute-is-accessed(self.^name, 'MaximumPortVLANID');
    $!MaximumVLANID                                     = self.etl-text(:TAG<MaximumVLANID>,                                        :$!xml)             if self.attribute-is-accessed(self.^name, 'MaximumVLANID');
    $!MinimumEthernetCapacityGranularity                = self.etl-text(:TAG<MinimumEthernetCapacityGranularity>,                   :$!xml)             if self.attribute-is-accessed(self.^name, 'MinimumEthernetCapacityGranularity');
    $!MinimumPortVLANID                                 = self.etl-text(:TAG<MinimumPortVLANID>,                                    :$!xml)             if self.attribute-is-accessed(self.^name, 'MinimumPortVLANID');
    $!MinimumVLANID                                     = self.etl-text(:TAG<MinimumVLANID>,                                        :$!xml)             if self.attribute-is-accessed(self.^name, 'MinimumVLANID');
    $!MaxSupportedEthernetLogicalPorts                  = self.etl-text(:TAG<MaxSupportedEthernetLogicalPorts>,                     :$!xml)             if self.attribute-is-accessed(self.^name, 'MaxSupportedEthernetLogicalPorts');
    $!MaximumAllowedEthVLANs                            = self.etl-text(:TAG<MaximumAllowedEthVLANs>,                               :$!xml)             if self.attribute-is-accessed(self.^name, 'MaximumAllowedEthVLANs');
    $!MaximumAllowedEthMACs                             = self.etl-text(:TAG<MaximumAllowedEthMACs>,                                :$!xml)             if self.attribute-is-accessed(self.^name, 'MaximumAllowedEthMACs');
    $!ConfiguredMaxFiberChannelOverEthernetLogicalPorts = self.etl-text(:TAG<ConfiguredMaxFiberChannelOverEthernetLogicalPorts>,    :$!xml)             if self.attribute-is-accessed(self.^name, 'ConfiguredMaxFiberChannelOverEthernetLogicalPorts');
    $!DefaultFiberChannelTargetsForBackingDevice        = self.etl-text(:TAG<DefaultFiberChannelTargetsForBackingDevice>,           :$!xml)             if self.attribute-is-accessed(self.^name, 'DefaultFiberChannelTargetsForBackingDevice');
    $!DefaultFiberChannelTargetsForNonBackingDevice     = self.etl-text(:TAG<DefaultFiberChannelTargetsForNonBackingDevice>,        :$!xml)             if self.attribute-is-accessed(self.^name, 'DefaultFiberChannelTargetsForNonBackingDevice');
    $!ConfiguredFiberChannelOverEthernetLogicalPorts    = self.etl-text(:TAG<ConfiguredFiberChannelOverEthernetLogicalPorts>,       :$!xml)             if self.attribute-is-accessed(self.^name, 'ConfiguredFiberChannelOverEthernetLogicalPorts');
    $!FiberChannelTargetsRoundingValue                  = self.etl-text(:TAG<FiberChannelTargetsRoundingValue>,                     :$!xml)             if self.attribute-is-accessed(self.^name, 'FiberChannelTargetsRoundingValue');
    $!MaxSupportedFiberChannelOverEthernetLogicalPorts  = self.etl-text(:TAG<MaxSupportedFiberChannelOverEthernetLogicalPorts>,     :$!xml)             if self.attribute-is-accessed(self.^name, 'MaxSupportedFiberChannelOverEthernetLogicalPorts');
    $!MaximumFiberChannelTargets                        = self.etl-text(:TAG<MaximumFiberChannelTargets>,                           :$!xml)             if self.attribute-is-accessed(self.^name, 'MaximumFiberChannelTargets');
    $!xml                                               = Nil;
    $!initialized                                       = True;
    self;
}

=finish
