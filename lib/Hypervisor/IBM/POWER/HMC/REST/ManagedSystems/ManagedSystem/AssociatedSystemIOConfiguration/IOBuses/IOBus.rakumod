need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOBuses::IOBus::IOSlots;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOBuses::IOBus:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                                                                                                        $names-checked  = False;
my      Bool                                                                                                                        $analyzed       = False;
my      Lock                                                                                                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config                                                                                   $.config        is required;
has     Bool                                                                                                                        $.initialized   = False;
has     Str                                                                                                                         $.BackplanePhysicalLocation                 is conditional-initialization-attribute;
has     Str                                                                                                                         $.BusDynamicReconfigurationConnectorIndex   is conditional-initialization-attribute;
has     Str                                                                                                                         $.BusDynamicReconfigurationConnectorName    is conditional-initialization-attribute;
has     Str                                                                                                                         $.IOBusID                                   is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOBuses::IOBus::IOSlots  $.IOSlots                                   is conditional-initialization-attribute;

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
    $!BackplanePhysicalLocation                 = self.etl-text(:TAG<BackplanePhysicalLocation>,                :$!xml) if self.attribute-is-accessed(self.^name, 'BackplanePhysicalLocation');
    $!BusDynamicReconfigurationConnectorIndex   = self.etl-text(:TAG<BusDynamicReconfigurationConnectorIndex>,  :$!xml) if self.attribute-is-accessed(self.^name, 'BusDynamicReconfigurationConnectorIndex');
    $!BusDynamicReconfigurationConnectorName    = self.etl-text(:TAG<BusDynamicReconfigurationConnectorName>,   :$!xml) if self.attribute-is-accessed(self.^name, 'BusDynamicReconfigurationConnectorName');
    $!IOBusID                                   = self.etl-text(:TAG<IOBusID>,                                  :$!xml) if self.attribute-is-accessed(self.^name, 'IOBusID');
    if self.attribute-is-accessed(self.^name, 'IOSlots') {
        $!IOSlots                               = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOBuses::IOBus::IOSlots.new(:$!config, :xml(self.etl-branch(:TAG<IOSlots>, :$!xml, :optional)));
    }
    $!xml                                       = Nil;
    $!initialized                               = True;
    self;
}

=finish
