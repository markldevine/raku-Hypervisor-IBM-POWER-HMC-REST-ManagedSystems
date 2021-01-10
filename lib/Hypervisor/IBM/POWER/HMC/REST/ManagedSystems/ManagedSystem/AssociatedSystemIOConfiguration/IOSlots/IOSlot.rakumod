need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot::RelatedIBMiIOSlot;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot::RelatedIOAdapter;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot::IORDevices;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                                                                                                                    $names-checked  = False;
my      Bool                                                                                                                                    $analyzed       = False;
my      Lock                                                                                                                                    $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config                                                                                               $.config        is required;
has     Bool                                                                                                                                    $.initialized   = False;
has     Str                                                                                                                                     $.BusGroupingRequired                       is conditional-initialization-attribute;
has     Str                                                                                                                                     $.Description                               is conditional-initialization-attribute;
has     Str                                                                                                                                     @.FeatureCodes                              is conditional-initialization-attribute;
has     Str                                                                                                                                     $.IOUnitPhysicalLocation                    is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PartitionID                               is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PartitionName                             is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PartitionType                             is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PCAdapterID                               is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PCIClass                                  is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PCIDeviceID                               is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PCISubsystemDeviceID                      is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PCIManufacturerID                         is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PCIRevisionID                             is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PCIVendorID                               is conditional-initialization-attribute;
has     Str                                                                                                                                     $.PCISubsystemVendorID                      is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot::RelatedIBMiIOSlot   $.RelatedIBMiIOSlot                         is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot::RelatedIOAdapter    $.RelatedIOAdapter                          is conditional-initialization-attribute;
has     Str                                                                                                                                     $.SlotDynamicReconfigurationConnectorIndex  is conditional-initialization-attribute;
has     Str                                                                                                                                     $.SlotDynamicReconfigurationConnectorName   is conditional-initialization-attribute;
has     Str                                                                                                                                     $.SlotPhysicalLocationCode                  is conditional-initialization-attribute;
has     Str                                                                                                                                     $.SRIOVCapableDevice                        is conditional-initialization-attribute;
has     Str                                                                                                                                     $.SRIOVCapableSlot                          is conditional-initialization-attribute;
has     Str                                                                                                                                     $.SRIOVLogicalPortsLimit                    is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot::IORDevices          $.IORDevices                                is conditional-initialization-attribute;

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
    return self                                 if $!initialized;
    self.config.diag.post:                      self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    $!BusGroupingRequired                       = self.etl-text(:TAG<BusGroupingRequired>,                      :$!xml)             if self.attribute-is-accessed(self.^name, 'BusGroupingRequired');
    $!Description                               = self.etl-text(:TAG<Description>,                              :$!xml)             if self.attribute-is-accessed(self.^name, 'Description');
    @!FeatureCodes                              = self.etl-texts(:TAG<FeatureCodes>,                            :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'FeatureCodes');
    $!IOUnitPhysicalLocation                    = self.etl-text(:TAG<IOUnitPhysicalLocation>,                   :$!xml)             if self.attribute-is-accessed(self.^name, 'IOUnitPhysicalLocation');
    $!PartitionID                               = self.etl-text(:TAG<PartitionID>,                              :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PartitionID');
    $!PartitionName                             = self.etl-text(:TAG<PartitionName>,                            :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PartitionName');
    $!PartitionType                             = self.etl-text(:TAG<PartitionType>,                            :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PartitionType');
    $!PCAdapterID                               = self.etl-text(:TAG<PCAdapterID>,                              :$!xml)             if self.attribute-is-accessed(self.^name, 'PCAdapterID');
    $!PCIClass                                  = self.etl-text(:TAG<PCIClass>,                                 :$!xml)             if self.attribute-is-accessed(self.^name, 'PCIClass');
    $!PCIDeviceID                               = self.etl-text(:TAG<PCIDeviceID>,                              :$!xml)             if self.attribute-is-accessed(self.^name, 'PCIDeviceID');
    $!PCISubsystemDeviceID                      = self.etl-text(:TAG<PCISubsystemDeviceID>,                     :$!xml)             if self.attribute-is-accessed(self.^name, 'PCISubsystemDeviceID');
    $!PCIManufacturerID                         = self.etl-text(:TAG<PCIManufacturerID>,                        :$!xml)             if self.attribute-is-accessed(self.^name, 'PCIManufacturerID');
    $!PCIRevisionID                             = self.etl-text(:TAG<PCIRevisionID>,                            :$!xml)             if self.attribute-is-accessed(self.^name, 'PCIRevisionID');
    $!PCIVendorID                               = self.etl-text(:TAG<PCIVendorID>,                              :$!xml)             if self.attribute-is-accessed(self.^name, 'PCIVendorID');
    $!PCISubsystemVendorID                      = self.etl-text(:TAG<PCISubsystemVendorID>,                     :$!xml)             if self.attribute-is-accessed(self.^name, 'PCISubsystemVendorID');
    if self.attribute-is-accessed(self.^name, 'RelatedIBMiIOSlot') {
        $!RelatedIBMiIOSlot     = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot::RelatedIBMiIOSlot.new(:$!config, :xml(self.etl-branch(:TAG<RelatedIBMiIOSlot>, :$!xml)));
    }
    if self.attribute-is-accessed(self.^name, 'RelatedIOAdapter') {
        $!RelatedIOAdapter      = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot::RelatedIOAdapter.new(:$!config, :xml(self.etl-branch(:TAG<RelatedIOAdapter>, :$!xml)));
    }
    $!SlotDynamicReconfigurationConnectorIndex  = self.etl-text(:TAG<SlotDynamicReconfigurationConnectorIndex>, :$!xml)             if self.attribute-is-accessed(self.^name, 'SlotDynamicReconfigurationConnectorIndex');
    $!SlotDynamicReconfigurationConnectorName   = self.etl-text(:TAG<SlotDynamicReconfigurationConnectorName>,  :$!xml)             if self.attribute-is-accessed(self.^name, 'SlotDynamicReconfigurationConnectorName');
    $!SlotPhysicalLocationCode                  = self.etl-text(:TAG<SlotPhysicalLocationCode>,                 :$!xml)             if self.attribute-is-accessed(self.^name, 'SlotPhysicalLocationCode');
    $!SRIOVCapableDevice                        = self.etl-text(:TAG<SRIOVCapableDevice>,                       :$!xml)             if self.attribute-is-accessed(self.^name, 'SRIOVCapableDevice');
    $!SRIOVCapableSlot                          = self.etl-text(:TAG<SRIOVCapableSlot>,                         :$!xml)             if self.attribute-is-accessed(self.^name, 'SRIOVCapableSlot');
    $!SRIOVLogicalPortsLimit                    = self.etl-text(:TAG<SRIOVLogicalPortsLimit>,                   :$!xml)             if self.attribute-is-accessed(self.^name, 'SRIOVLogicalPortsLimit');
    if self.attribute-is-accessed(self.^name, 'IORDevices') {
        $!IORDevices            = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot::IORDevices.new(:$!config, :xml(self.etl-branch(:TAG<IORDevices>, :$!xml, :optional)));
    }
    $!xml                                       = Nil;
    $!initialized                               = True;
    self;
}

=finish
