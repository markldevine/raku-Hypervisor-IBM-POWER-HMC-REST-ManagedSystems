need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOBuses::IOBus::IOSlots::IOSlot::RelatedIOAdapter::IOAdapter:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         $.AdapterID                             is conditional-initialization-attribute;
has     Str                                         $.Description                           is conditional-initialization-attribute;
has     Str                                         $.DeviceName                            is conditional-initialization-attribute;
has     Str                                         $.DynamicReconfigurationConnectorName   is conditional-initialization-attribute;
has     Str                                         $.PhysicalLocation                      is conditional-initialization-attribute;
has     Str                                         $.UniqueDeviceID                        is conditional-initialization-attribute;
has     Str                                         $.LogicalPartitionAssignmentCapable     is conditional-initialization-attribute;
has     Str                                         $.DynamicPartitionAssignmentCapable     is conditional-initialization-attribute;

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
    return self                             if $!initialized;
    self.config.diag.post:                  self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    $!AdapterID                             = self.etl-text(:TAG<AdapterID>,                            :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'AdapterID');
    $!Description                           = self.etl-text(:TAG<Description>,                          :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'Description');
    $!DeviceName                            = self.etl-text(:TAG<DeviceName>,                           :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'DeviceName');
    $!DynamicReconfigurationConnectorName   = self.etl-text(:TAG<DynamicReconfigurationConnectorName>,  :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'DynamicReconfigurationConnectorName');
    $!PhysicalLocation                      = self.etl-text(:TAG<PhysicalLocation>,                     :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'PhysicalLocation');
    $!UniqueDeviceID                        = self.etl-text(:TAG<UniqueDeviceID>,                       :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'UniqueDeviceID');
    $!LogicalPartitionAssignmentCapable     = self.etl-text(:TAG<LogicalPartitionAssignmentCapable>,    :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'LogicalPartitionAssignmentCapable');
    $!DynamicPartitionAssignmentCapable     = self.etl-text(:TAG<DynamicPartitionAssignmentCapable>,    :$!xml, :optional) if self.attribute-is-accessed(self.^name, 'DynamicPartitionAssignmentCapable');
    $!xml                                   = Nil;
    $!initialized                           = True;
    self;
}

=finish
