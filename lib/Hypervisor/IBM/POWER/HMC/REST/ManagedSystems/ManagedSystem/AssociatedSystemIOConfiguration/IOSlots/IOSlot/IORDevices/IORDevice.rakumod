need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots::IOSlot::IORDevices::IORDevice:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         $.ParentDynamicReconfigurationConnectorIndex    is conditional-initialization-attribute;
has     Str                                         $.ParentName                                    is conditional-initialization-attribute;
has     Str                                         $.PCIDeviceId                                   is conditional-initialization-attribute;
has     Str                                         $.PCIVendorId                                   is conditional-initialization-attribute;
has     Str                                         $.PCISubsystemDeviceId                          is conditional-initialization-attribute;
has     Str                                         $.PCISubsystemVendorId                          is conditional-initialization-attribute;
has     Str                                         $.PCIRevisionId                                 is conditional-initialization-attribute;
has     Str                                         $.ProgrammingInterfaceClass                     is conditional-initialization-attribute;
has     Str                                         $.PCIClassCode                                  is conditional-initialization-attribute;
has     Str                                         $.DeviceType                                    is conditional-initialization-attribute;
has     Str                                         $.PrimaryDeviceFunction                         is conditional-initialization-attribute;
has     Str                                         $.SerialNumber                                  is conditional-initialization-attribute;
has     Str                                         $.PartNumber                                    is conditional-initialization-attribute;
has     Str                                         $.SlotChildId                                   is conditional-initialization-attribute;
has     Str                                         $.LocationCode                                  is conditional-initialization-attribute;
has     Str                                         $.MacAddressValue                               is conditional-initialization-attribute;
has     Str                                         $.Description                                   is conditional-initialization-attribute;
has     Str                                         $.CCIN                                          is conditional-initialization-attribute;
has     Str                                         $.FruNumber                                     is conditional-initialization-attribute;
has     Str                                         $.MicroCodeVersion                              is conditional-initialization-attribute;
has     Str                                         $.NumEnclosureBays                              is conditional-initialization-attribute;
has     Str                                         $.ParentSlotChildId                             is conditional-initialization-attribute;
has     Str                                         $.SizeMetric                                    is conditional-initialization-attribute;
has     Str                                         $.Size                                          is conditional-initialization-attribute;
has     Str                                         $.WWNN                                          is conditional-initialization-attribute;
has     Str                                         $.WWPN;

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
    $!ParentDynamicReconfigurationConnectorIndex    = self.etl-text(:TAG<ParentDynamicReconfigurationConnectorIndex>,   :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'ParentDynamicReconfigurationConnectorIndex');
    $!ParentName                                    = self.etl-text(:TAG<ParentName>,                                   :$!xml)             if self.attribute-is-accessed(self.^name, 'ParentName');
    $!PCIDeviceId                                   = self.etl-text(:TAG<PCIDeviceId>,                                  :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PCIDeviceId');
    $!PCIVendorId                                   = self.etl-text(:TAG<PCIVendorId>,                                  :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PCIVendorId');
    $!PCISubsystemDeviceId                          = self.etl-text(:TAG<PCISubsystemDeviceId>,                         :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PCISubsystemDeviceId');
    $!PCISubsystemVendorId                          = self.etl-text(:TAG<PCISubsystemVendorId>,                         :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PCISubsystemVendorId');
    $!PCIRevisionId                                 = self.etl-text(:TAG<PCIRevisionId>,                                :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PCIRevisionId');
    $!ProgrammingInterfaceClass                     = self.etl-text(:TAG<ProgrammingInterfaceClass>,                    :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'ProgrammingInterfaceClass');
    $!PCIClassCode                                  = self.etl-text(:TAG<PCIClassCode>,                                 :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PCIClassCode');
    $!DeviceType                                    = self.etl-text(:TAG<DeviceType>,                                   :$!xml)             if self.attribute-is-accessed(self.^name, 'DeviceType');
    $!PrimaryDeviceFunction                         = self.etl-text(:TAG<PrimaryDeviceFunction>,                        :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PrimaryDeviceFunction');
    $!SerialNumber                                  = self.etl-text(:TAG<SerialNumber>,                                 :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'SerialNumber');
    $!PartNumber                                    = self.etl-text(:TAG<PartNumber>,                                   :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'PartNumber');
    $!SlotChildId                                   = self.etl-text(:TAG<SlotChildId>,                                  :$!xml)             if self.attribute-is-accessed(self.^name, 'SlotChildId');
    $!LocationCode                                  = self.etl-text(:TAG<LocationCode>,                                 :$!xml)             if self.attribute-is-accessed(self.^name, 'LocationCode');
    $!MacAddressValue                               = self.etl-text(:TAG<MacAddressValue>,                              :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'MacAddressValue');
    $!Description                                   = self.etl-text(:TAG<Description>,                                  :$!xml)             if self.attribute-is-accessed(self.^name, 'Description');
    $!CCIN                                          = self.etl-text(:TAG<CCIN>,                                         :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'CCIN');
    $!FruNumber                                     = self.etl-text(:TAG<FruNumber>,                                    :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'FruNumber');
    $!MicroCodeVersion                              = self.etl-text(:TAG<MicroCodeVersion>,                             :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'MicroCodeVersion');
    $!NumEnclosureBays                              = self.etl-text(:TAG<NumEnclosureBays>,                             :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'NumEnclosureBays');
    $!ParentSlotChildId                             = self.etl-text(:TAG<ParentSlotChildId>,                            :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'ParentSlotChildId');
    $!SizeMetric                                    = self.etl-text(:TAG<SizeMetric>,                                   :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'SizeMetric');
    $!Size                                          = self.etl-text(:TAG<Size>,                                         :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'Size');
    $!WWNN                                          = self.etl-text(:TAG<WWNN>,                                         :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'WWNN');
    $!WWPN                                          = self.etl-text(:TAG<WWPN>,                                         :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'WWPN');
    $!xml                                           = Nil;
    $!initialized                                   = True;
    self;
}

=finish
