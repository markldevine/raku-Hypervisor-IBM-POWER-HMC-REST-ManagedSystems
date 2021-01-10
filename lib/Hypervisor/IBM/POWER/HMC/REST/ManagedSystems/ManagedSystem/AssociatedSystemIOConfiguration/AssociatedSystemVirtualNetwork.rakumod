need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
use     URI;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::AssociatedSystemVirtualNetwork:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     URI                                         @.NetworkBridges                            is conditional-initialization-attribute;
has     Str                                         $.VirtualEthernetAdapterMACAddressPrefix    is conditional-initialization-attribute;
has     URI                                         @.VirtualNetworks                           is conditional-initialization-attribute;
has     URI                                         @.VirtualSwitches                           is conditional-initialization-attribute;

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
    self.config.diag.post:  self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    @!NetworkBridges        = self.etl-links-URIs(:xml(self.etl-branch(:TAG<NetworkBridges>,    :$!xml, :optional)))    if self.attribute-is-accessed(self.^name, 'NetworkBridges');
    @!VirtualNetworks       = self.etl-links-URIs(:xml(self.etl-branch(:TAG<VirtualNetworks>,   :$!xml, :optional)))    if self.attribute-is-accessed(self.^name, 'VirtualNetworks');
    @!VirtualSwitches       = self.etl-links-URIs(:xml(self.etl-branch(:TAG<VirtualSwitches>,   :$!xml)))               if self.attribute-is-accessed(self.^name, 'VirtualSwitches');
    $!xml                   = Nil;
    $!initialized           = True;
    self;
}

=finish
