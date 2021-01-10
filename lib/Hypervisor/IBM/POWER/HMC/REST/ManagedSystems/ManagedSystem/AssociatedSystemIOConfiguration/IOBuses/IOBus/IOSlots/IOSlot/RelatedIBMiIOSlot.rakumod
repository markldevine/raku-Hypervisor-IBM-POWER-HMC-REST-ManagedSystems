need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration::IOBuses::IOBus::IOSlots::IOSlot::RelatedIBMiIOSlot:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         $.AlternateLoadSourceAttached       is conditional-initialization-attribute;
has     Str                                         $.ConsoleCapable                    is conditional-initialization-attribute;
has     Str                                         $.DirectOperationsConsoleCapable    is conditional-initialization-attribute;
has     Str                                         $.IOP                               is conditional-initialization-attribute;
has     Str                                         $.IOPInfoStale                      is conditional-initialization-attribute;
has     Str                                         $.IOPoolID                          is conditional-initialization-attribute;
has     Str                                         $.LANConsoleCapable                 is conditional-initialization-attribute;
has     Str                                         $.LoadSourceAttached                is conditional-initialization-attribute;
has     Str                                         $.LoadSourceCapable                 is conditional-initialization-attribute;
has     Str                                         $.OperationsConsoleAttached         is conditional-initialization-attribute;
has     Str                                         $.OperationsConsoleCapable          is conditional-initialization-attribute;

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
    $!AlternateLoadSourceAttached       = self.etl-text(:TAG<AlternateLoadSourceAttached>,      :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'AlternateLoadSourceAttached');
    $!ConsoleCapable                    = self.etl-text(:TAG<ConsoleCapable>,                   :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'ConsoleCapable');
    $!DirectOperationsConsoleCapable    = self.etl-text(:TAG<DirectOperationsConsoleCapable>,   :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'DirectOperationsConsoleCapable');
    $!IOP                               = self.etl-text(:TAG<IOP>,                              :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'IOP');
    $!IOPInfoStale                      = self.etl-text(:TAG<IOPInfoStale>,                     :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'IOPInfoStale');
    $!IOPoolID                          = self.etl-text(:TAG<IOPoolID>,                         :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'IOPoolID');
    $!LANConsoleCapable                 = self.etl-text(:TAG<LANConsoleCapable>,                :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'LANConsoleCapable');
    $!LoadSourceAttached                = self.etl-text(:TAG<LoadSourceAttached>,               :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'LoadSourceAttached');
    $!LoadSourceCapable                 = self.etl-text(:TAG<LoadSourceCapable>,                :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'LoadSourceCapable');
    $!OperationsConsoleAttached         = self.etl-text(:TAG<OperationsConsoleAttached>,        :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'OperationsConsoleAttached');
    $!OperationsConsoleCapable          = self.etl-text(:TAG<OperationsConsoleCapable>,         :$!xml, :optional)  if self.attribute-is-accessed(self.^name, 'OperationsConsoleCapable');
    $!xml                               = Nil;
    $!initialized                       = True;
    self;
}

=finish
