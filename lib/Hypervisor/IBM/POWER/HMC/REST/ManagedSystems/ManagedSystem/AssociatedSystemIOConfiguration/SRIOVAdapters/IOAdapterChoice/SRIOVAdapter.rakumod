need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter::ConvergedEthernetPhysicalPorts;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter::EthernetLogicalPorts;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter::UnconfiguredLogicalPorts;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                                                                                                                                                            $names-checked  = False;
my      Bool                                                                                                                                                                            $analyzed       = False;
my      Lock                                                                                                                                                                            $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config                                                                                                                                       $.config        is required;
has     Bool                                                                                                                                                                            $.initialized   = False;
has     Str                                                                                                                                                                             $.AdapterID                         is conditional-initialization-attribute;
has     Str                                                                                                                                                                             $.Description                       is conditional-initialization-attribute;
has     Str                                                                                                                                                                             $.PhysicalLocation                  is conditional-initialization-attribute;
has     Str                                                                                                                                                                             $.SRIOVAdapterID                    is conditional-initialization-attribute;
has     Str                                                                                                                                                                             $.AdapterState                      is conditional-initialization-attribute;
has     Str                                                                                                                                                                             $.AdapterMode                       is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter::ConvergedEthernetPhysicalPorts $.ConvergedEthernetPhysicalPorts    is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter::EthernetLogicalPorts           $.EthernetLogicalPorts              is conditional-initialization-attribute;
has     Str                                                                                                                                                                             $.IsFunctional                      is conditional-initialization-attribute;
has     Str                                                                                                                                                                             $.MaximumHugeDMALogicalPorts        is conditional-initialization-attribute;
has     Str                                                                                                                                                                             $.MaximumLogicalPortsSupported      is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter::UnconfiguredLogicalPorts       $.UnconfiguredLogicalPorts          is conditional-initialization-attribute;
has     Str                                                                                                                                                                             $.Personality                       is conditional-initialization-attribute;

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
    return self                         if $!initialized;
    self.config.diag.post:              self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    $!AdapterID                         = self.etl-text(:TAG<AdapterID>,                    :$!xml)             if self.attribute-is-accessed(self.^name, 'AdapterID');
    $!Description                       = self.etl-text(:TAG<Description>,                  :$!xml)             if self.attribute-is-accessed(self.^name, 'Description');
    $!PhysicalLocation                  = self.etl-text(:TAG<PhysicalLocation>,             :$!xml)             if self.attribute-is-accessed(self.^name, 'PhysicalLocation');
    $!SRIOVAdapterID                    = self.etl-text(:TAG<SRIOVAdapterID>,               :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'SRIOVAdapterID');
    $!AdapterState                      = self.etl-text(:TAG<AdapterState>,                 :$!xml)             if self.attribute-is-accessed(self.^name, 'AdapterState');
    $!AdapterMode                       = self.etl-text(:TAG<AdapterMode>,                  :$!xml)             if self.attribute-is-accessed(self.^name, 'AdapterMode');
    if self.attribute-is-accessed(self.^name, 'ConvergedEthernetPhysicalPorts') {
        $!ConvergedEthernetPhysicalPorts    = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter::ConvergedEthernetPhysicalPorts.new(:$!config, :xml(self.etl-branch(:TAG<ConvergedEthernetPhysicalPorts>, :$!xml, :optional)));
    }
    if self.attribute-is-accessed(self.^name, 'EthernetLogicalPorts') {
        $!EthernetLogicalPorts              = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter::EthernetLogicalPorts.new(:$!config, :xml(self.etl-branch(:TAG<EthernetLogicalPorts>, :$!xml, :optional)));
    }
    $!IsFunctional                      = self.etl-text(:TAG<IsFunctional>,                 :$!xml)             if self.attribute-is-accessed(self.^name, 'IsFunctional');
    $!MaximumHugeDMALogicalPorts        = self.etl-text(:TAG<MaximumHugeDMALogicalPorts>,   :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'MaximumHugeDMALogicalPorts');
    $!MaximumLogicalPortsSupported      = self.etl-text(:TAG<MaximumLogicalPortsSupported>, :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'MaximumLogicalPortsSupported');
    if self.attribute-is-accessed(self.^name, 'UnconfiguredLogicalPorts') {
        $!UnconfiguredLogicalPorts          = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters::IOAdapterChoice::SRIOVAdapter::UnconfiguredLogicalPorts.new(:$!config, :xml(self.etl-branch(:TAG<UnconfiguredLogicalPorts>, :$!xml, :optional)));
    }
    $!Personality                       = self.etl-text(:TAG<Personality>,                  :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'Personality');
    $!xml                               = Nil;
    $!initialized                       = True;
    self;
}

=finish
