need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::SystemMigrationInformation:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;

has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         $.AllowInactiveSourceStorageVios        is conditional-initialization-attribute;
has     Str                                         $.MaximumInactiveMigrations             is conditional-initialization-attribute;
has     Str                                         $.MaximumActiveMigrations               is conditional-initialization-attribute;
has     Str                                         $.NumberOfInactiveMigrationsInProgress  is conditional-initialization-attribute;
has     Str                                         $.NumberOfActiveMigrationsInProgress    is conditional-initialization-attribute;
has     Str                                         $.MaximumFirmwareActiveMigrations       is conditional-initialization-attribute;
has     Str                                         $.LogicalPartitionAffinityCheckCapable  is conditional-initialization-attribute;
has     Str                                         $.InactiveProfileMigrationPolicy        is conditional-initialization-attribute;

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
    $!AllowInactiveSourceStorageVios        = self.etl-text(:TAG<AllowInactiveSourceStorageVios>,       :$!xml) if self.attribute-is-accessed(self.^name, 'AllowInactiveSourceStorageVios');
    $!MaximumInactiveMigrations             = self.etl-text(:TAG<MaximumInactiveMigrations>,            :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumInactiveMigrations');
    $!MaximumActiveMigrations               = self.etl-text(:TAG<MaximumActiveMigrations>,              :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumActiveMigrations');
    $!NumberOfInactiveMigrationsInProgress  = self.etl-text(:TAG<NumberOfInactiveMigrationsInProgress>, :$!xml) if self.attribute-is-accessed(self.^name, 'NumberOfInactiveMigrationsInProgress');
    $!NumberOfActiveMigrationsInProgress    = self.etl-text(:TAG<NumberOfActiveMigrationsInProgress>,   :$!xml) if self.attribute-is-accessed(self.^name, 'NumberOfActiveMigrationsInProgress');
    $!MaximumFirmwareActiveMigrations       = self.etl-text(:TAG<MaximumFirmwareActiveMigrations>,      :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumFirmwareActiveMigrations');
    $!LogicalPartitionAffinityCheckCapable  = self.etl-text(:TAG<LogicalPartitionAffinityCheckCapable>, :$!xml) if self.attribute-is-accessed(self.^name, 'LogicalPartitionAffinityCheckCapable');
    $!InactiveProfileMigrationPolicy        = self.etl-text(:TAG<InactiveProfileMigrationPolicy>,       :$!xml) if self.attribute-is-accessed(self.^name, 'InactiveProfileMigrationPolicy');
    $!xml                                   = Nil;
    $!initialized                           = True;
    self;
}

=finish
