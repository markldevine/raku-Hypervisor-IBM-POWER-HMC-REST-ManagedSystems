need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOAdapters;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOBuses;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::AssociatedSystemVirtualNetwork;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                                                                                                                $names-checked  = False;
my      Bool                                                                                                                                $analyzed       = False;
my      Lock                                                                                                                                $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config                                                                                           $.config        is required;
has     Bool                                                                                                                                $.initialized   = False;
has     Str                                                                                                                                 $.AvailableWWPNs                    is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOAdapters                       $.IOAdapters                        is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOBuses                          $.IOBuses                           is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots                          $.IOSlots                           is conditional-initialization-attribute;
has     Str                                                                                                                                 $.MaximumIOPools                    is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters                    $.SRIOVAdapters                     is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::AssociatedSystemVirtualNetwork   $.AssociatedSystemVirtualNetwork    is conditional-initialization-attribute;
has     Str                                                                                                                                 $.WWPNPrefix                        is conditional-initialization-attribute;

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
    $!AvailableWWPNs                        = self.etl-text(:TAG<AvailableWWPNs>,   :$!xml) if self.attribute-is-accessed(self.^name, 'AvailableWWPNs');
    if self.attribute-is-accessed(self.^name, 'IOAdapters') {
        $!IOAdapters                        = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOAdapters.new(:$!config, :xml(self.etl-branch(:TAG<IOAdapters>, :$!xml)));
    }
    if self.attribute-is-accessed(self.^name, 'IOBuses') {
        $!IOBuses                           = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOBuses.new(:$!config, :xml(self.etl-branch(:TAG<IOBuses>, :$!xml)));
    }
    if self.attribute-is-accessed(self.^name, 'IOSlots') {
        $!IOSlots                           = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOSlots.new(:$!config, :xml(self.etl-branch(:TAG<IOSlots>, :$!xml)));
    }
    $!MaximumIOPools                        = self.etl-text(:TAG<MaximumIOPools>,   :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumIOPools');
    if self.attribute-is-accessed(self.^name, 'SRIOVAdapters') {
        $!SRIOVAdapters                     = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::SRIOVAdapters.new(:$!config, :xml(self.etl-branch(:TAG<SRIOVAdapters>, :$!xml)));
    }
    if self.attribute-is-accessed(self.^name, 'AssociatedSystemVirtualNetwork') {
        $!AssociatedSystemVirtualNetwork    = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::AssociatedSystemVirtualNetwork.new(:$!config, :xml(self.etl-branch(:TAG<AssociatedSystemVirtualNetwork>, :$!xml)));
    }
    $!WWPNPrefix                            = self.etl-text(:TAG<WWPNPrefix>,       :$!xml) if self.attribute-is-accessed(self.^name, 'WWPNPrefix');
    $!xml                                   = Nil;
    $!initialized                           = True;
    self;
}

=finish
