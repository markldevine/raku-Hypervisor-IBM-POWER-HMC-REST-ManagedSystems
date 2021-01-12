need    Hypervisor::IBM::POWER::HMC::REST::Atom;
need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedIPLConfiguration;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemCapabilities;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemMemoryConfiguration;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemProcessorConfiguration;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemSecurity;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::MachineTypeModelAndSerialNumber;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::SystemMigrationInformation;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::EnergyManagementConfiguration;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::LogicalPartitions;
need    Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::VirtualIOServers;
use     URI;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                                                                                        $names-checked                                  = False;
my      Bool                                                                                                        $analyzed                                       = False;
my      Lock                                                                                                        $lock                                           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config                                                                   $.config                                        is required;
has     Bool                                                                                                        $.initialized                                   = False;
has     Hypervisor::IBM::POWER::HMC::REST::Atom                                                                     $.atom                                          is conditional-initialization-attribute;
has     Str                                                                                                         $.id;                                                                                       # used in parent class as part of instantiation
has     DateTime                                                                                                    $.published                                     is conditional-initialization-attribute;
has     Str                                                                                                         $.ActivatedLevel                                is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedIPLConfiguration                $.AssociatedIPLConfiguration                    is conditional-initialization-attribute;
has     URI                                                                                                         @.AssociatedLogicalPartitions                   is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemCapabilities              $.AssociatedSystemCapabilities                  is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration           $.AssociatedSystemIOConfiguration               is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemMemoryConfiguration       $.AssociatedSystemMemoryConfiguration           is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemProcessorConfiguration    $.AssociatedSystemProcessorConfiguration        is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemSecurity                  $.AssociatedSystemSecurity                      is conditional-initialization-attribute;
has     URI                                                                                                         @.AssociatedVirtualIOServers                    is conditional-initialization-attribute;
has     Str                                                                                                         $.DetailedState                                 is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::MachineTypeModelAndSerialNumber           $.MachineTypeModelAndSerialNumber               is conditional-initialization-attribute;
has     Str                                                                                                         $.ManufacturingDefaultConfigurationEnabled      is conditional-initialization-attribute;
has     Str                                                                                                         $.MaximumPartitions                             is conditional-initialization-attribute;
has     Str                                                                                                         $.MaximumPowerControlPartitions                 is conditional-initialization-attribute;
has     Str                                                                                                         $.MaximumRemoteRestartPartitions                is conditional-initialization-attribute;
has     Str                                                                                                         $.MaximumSharedProcessorCapablePartitionID      is conditional-initialization-attribute;
has     Str                                                                                                         $.MaximumSuspendablePartitions                  is conditional-initialization-attribute;
has     Str                                                                                                         $.MaximumBackingDevicesPerVNIC                  is conditional-initialization-attribute;
has     Str                                                                                                         $.PhysicalSystemAttentionLEDState               is conditional-initialization-attribute;
has     Str                                                                                                         $.PrimaryIPAddress                              is conditional-initialization-attribute;
has     Str                                                                                                         $.Hostname                                      is conditional-initialization-attribute;
has     Str                                                                                                         $.ServiceProcessorFailoverEnabled               is conditional-initialization-attribute;
has     Str                                                                                                         $.ServiceProcessorFailoverReason                is conditional-initialization-attribute;
has     Str                                                                                                         $.ServiceProcessorFailoverState                 is conditional-initialization-attribute;
has     Str                                                                                                         $.ServiceProcessorVersion                       is conditional-initialization-attribute;
has     Str                                                                                                         $.State                                         is conditional-initialization-attribute;
has     Str                                                                                                         $.SystemName;                                                                               # used in parent class as part of instantiation
has     DateTime                                                                                                    $.SystemTime                                    is conditional-initialization-attribute;
has     Str                                                                                                         $.VirtualSystemAttentionLEDState                is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::SystemMigrationInformation                $.SystemMigrationInformation                    is conditional-initialization-attribute;
has     Str                                                                                                         $.ReferenceCode                                 is conditional-initialization-attribute;
has     Str                                                                                                         $.MergedReferenceCode                           is conditional-initialization-attribute;
has     Str                                                                                                         $.SystemFirmware                                is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::EnergyManagementConfiguration             $.EnergyManagementConfiguration                 is conditional-initialization-attribute;
has     Str                                                                                                         $.IsPowerVMManagementMaster                     is conditional-initialization-attribute;
has     Str                                                                                                         $.IsClassicHMCManagement                        is conditional-initialization-attribute;
has     Str                                                                                                         $.IsPowerVMManagementWithoutMaster              is conditional-initialization-attribute;
has     Str                                                                                                         $.IsManagementPartitionPowerVMManagementMaster  is conditional-initialization-attribute;
has     Str                                                                                                         $.IsHMCPowerVMManagementMaster                  is conditional-initialization-attribute;
has     Str                                                                                                         $.IsNotPowerVMManagementMaster                  is conditional-initialization-attribute;
has     Str                                                                                                         $.IsPowerVMManagementNormalMaster               is conditional-initialization-attribute;
has     Str                                                                                                         $.IsPowerVMManagementPersistentMaster           is conditional-initialization-attribute;
has     Str                                                                                                         $.IsPowerVMManagementTemporaryMaster            is conditional-initialization-attribute;
has     Str                                                                                                         $.IsPowerVMManagementPartitionEnabled           is conditional-initialization-attribute;
has     Str                                                                                                         $.SystemType                                    is conditional-initialization-attribute;
has     Str                                                                                                         $.ProcessorThrottling                           is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::LogicalPartitions                         $.LogicalPartitions                             is conditional-initialization-attribute;
has     Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::VirtualIOServers                          $.VirtualIOServers                              is conditional-initialization-attribute;

method  xml-name-exceptions () { return set <Metadata author content etag:etag link title>; }

submethod TWEAK {
    self.config.diag.post:      self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_SUBMETHOD>;
    self.config.diag.post:      sprintf("%-20s %10s: %11s", self.^name.subst(/^.+'::'(.+)$/, {$0}), 'START', 't' ~ $*THREAD.id) if %*ENV<HIPH_THREAD_START>;
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
    my $init-start                                      = now;
    my $xml-content                                     = self.etl-branch(:TAG<content>,                                :$!xml);
    my $xml-ManagedSystem                               = self.etl-branch(:TAG<ManagedSystem:ManagedSystem>,            :xml($xml-content));
    $!atom                                              = self.etl-atom(:xml(self.etl-branch(:TAG<Metadata>,            :xml($xml-ManagedSystem))))                                                 if self.attribute-is-accessed(self.^name, 'atom');
    $!id                                                = self.etl-text(:TAG<id>,                                       :$!xml);
    $!published                                         = DateTime.new(self.etl-text(:TAG<published>,                   :$!xml))                                                                    if self.attribute-is-accessed(self.^name, 'published');
    $!ActivatedLevel                                    = self.etl-text(:TAG<ActivatedLevel>,                           :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'ActivatedLevel');
    if self.attribute-is-accessed(self.^name, 'AssociatedIPLConfiguration') {
        my $xml-AssociatedIPLConfiguration              = self.etl-branch(:TAG<AssociatedIPLConfiguration>,             :xml($xml-ManagedSystem));
        $!AssociatedIPLConfiguration                    = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedIPLConfiguration.new(:$!config, :xml($xml-AssociatedIPLConfiguration));
    }
    if self.attribute-is-accessed(self.^name, 'AssociatedLogicalPartitions') {
        my $xml-AssociatedLogicalPartitions             = self.etl-branch(:TAG<AssociatedLogicalPartitions>,            :xml($xml-ManagedSystem));
        @!AssociatedLogicalPartitions                   = self.etl-links-URIs(                                          :xml($xml-AssociatedLogicalPartitions));
    }
    if self.attribute-is-accessed(self.^name, 'AssociatedSystemCapabilities') {
        my $xml-AssociatedSystemCapabilities            = self.etl-branch(:TAG<AssociatedSystemCapabilities>,           :xml($xml-ManagedSystem));
        $!AssociatedSystemCapabilities                  = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemCapabilities.new(:$!config, :xml($xml-AssociatedSystemCapabilities));
    }
    if self.attribute-is-accessed(self.^name, 'AssociatedSystemIOConfiguration') {
        my $xml-AssociatedSystemIOConfiguration         = self.etl-branch(:TAG<AssociatedSystemIOConfiguration>,        :xml($xml-ManagedSystem));
        $!AssociatedSystemIOConfiguration               = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemIOConfiguration.new(:$!config, :xml($xml-AssociatedSystemIOConfiguration));
    }
    if self.attribute-is-accessed(self.^name, 'AssociatedSystemMemoryConfiguration') {
        my $xml-AssociatedSystemMemoryConfiguration     = self.etl-branch(:TAG<AssociatedSystemMemoryConfiguration>,    :xml($xml-ManagedSystem));
        $!AssociatedSystemMemoryConfiguration           = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemMemoryConfiguration.new(:$!config, :xml($xml-AssociatedSystemMemoryConfiguration));
    }
    if self.attribute-is-accessed(self.^name, 'AssociatedSystemProcessorConfiguration') {
        my $xml-AssociatedSystemProcessorConfiguration  = self.etl-branch(:TAG<AssociatedSystemProcessorConfiguration>, :xml($xml-ManagedSystem));
        $!AssociatedSystemProcessorConfiguration        = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemProcessorConfiguration.new(:$!config, :xml($xml-AssociatedSystemProcessorConfiguration));
    }
    if self.attribute-is-accessed(self.^name, 'AssociatedSystemSecurity') {
        my $xml-AssociatedSystemSecurity                = self.etl-branch(:TAG<AssociatedSystemSecurity>,               :xml($xml-ManagedSystem));
        $!AssociatedSystemSecurity                      = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemSecurity.new(:$!config, :xml($xml-AssociatedSystemSecurity));
    }
    if self.attribute-is-accessed(self.^name, 'AssociatedVirtualIOServers') {
        my $xml-AssociatedVirtualIOServers              = self.etl-branch(:TAG<AssociatedVirtualIOServers>,             :xml($xml-ManagedSystem));
        @!AssociatedVirtualIOServers                    = self.etl-links-URIs(                                          :xml($xml-AssociatedVirtualIOServers));
    }
    $!DetailedState                                     = self.etl-text(:TAG<DetailedState>,                            :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'DetailedState');
    if self.attribute-is-accessed(self.^name, 'MachineTypeModelAndSerialNumber') {
        my $xml-MachineTypeModelAndSerialNumber         = self.etl-branch(:TAG<MachineTypeModelAndSerialNumber>,        :xml($xml-ManagedSystem));
        $!MachineTypeModelAndSerialNumber               = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::MachineTypeModelAndSerialNumber.new(:$!config, :xml($xml-MachineTypeModelAndSerialNumber));
    }
    $!ManufacturingDefaultConfigurationEnabled          = self.etl-text(:TAG<ManufacturingDefaultConfigurationEnabled>, :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'ManufacturingDefaultConfigurationEnabled');
    $!MaximumPartitions                                 = self.etl-text(:TAG<MaximumPartitions>,                        :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'MaximumPartitions');
    $!MaximumPowerControlPartitions                     = self.etl-text(:TAG<MaximumPowerControlPartitions>,            :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'MaximumPowerControlPartitions');
    $!MaximumRemoteRestartPartitions                    = self.etl-text(:TAG<MaximumRemoteRestartPartitions>,           :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'MaximumRemoteRestartPartitions');
    $!MaximumSharedProcessorCapablePartitionID          = self.etl-text(:TAG<MaximumSharedProcessorCapablePartitionID>, :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'MaximumSharedProcessorCapablePartitionID');
    $!MaximumSuspendablePartitions                      = self.etl-text(:TAG<MaximumSuspendablePartitions>,             :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'MaximumSuspendablePartitions');
    $!MaximumBackingDevicesPerVNIC                      = self.etl-text(:TAG<MaximumBackingDevicesPerVNIC>,             :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'MaximumBackingDevicesPerVNIC');
    $!PhysicalSystemAttentionLEDState                   = self.etl-text(:TAG<PhysicalSystemAttentionLEDState>,          :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'PhysicalSystemAttentionLEDState');
    $!PrimaryIPAddress                                  = self.etl-text(:TAG<PrimaryIPAddress>,                         :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'PrimaryIPAddress');
    $!Hostname                                          = self.etl-text(:TAG<Hostname>,                                 :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'Hostname');
    $!ServiceProcessorFailoverEnabled                   = self.etl-text(:TAG<ServiceProcessorFailoverEnabled>,          :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'ServiceProcessorFailoverEnabled');
    $!ServiceProcessorFailoverReason                    = self.etl-text(:TAG<ServiceProcessorFailoverReason>,           :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'ServiceProcessorFailoverReason');
    $!ServiceProcessorFailoverState                     = self.etl-text(:TAG<ServiceProcessorFailoverState>,            :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'ServiceProcessorFailoverState');
    $!ServiceProcessorVersion                           = self.etl-text(:TAG<ServiceProcessorVersion>,                  :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'ServiceProcessorVersion');
    $!State                                             = self.etl-text(:TAG<State>,                                    :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'State');
    $!SystemName                                        = self.etl-text(:TAG<SystemName>,                               :xml($xml-ManagedSystem));
    $!SystemTime                                        = DateTime.new(self.etl-text(:TAG<SystemTime>,                  :xml($xml-ManagedSystem)).subst(/^(\d**10)(\d**3)$/, {$0 ~ '.' ~ $1}).Num)  if self.attribute-is-accessed(self.^name, 'SystemTime');
    $!VirtualSystemAttentionLEDState                    = self.etl-text(:TAG<VirtualSystemAttentionLEDState>,           :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'VirtualSystemAttentionLEDState');
    if self.attribute-is-accessed(self.^name, 'SystemMigrationInformation') {
        my $xml-SystemMigrationInformation              = self.etl-branch(:TAG<SystemMigrationInformation>,             :xml($xml-ManagedSystem));
        $!SystemMigrationInformation                    = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::SystemMigrationInformation.new(:$!config, :xml($xml-SystemMigrationInformation));
    }
    $!ReferenceCode                                     = self.etl-text(:TAG<ReferenceCode>,                            :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'ReferenceCode');
    $!MergedReferenceCode                               = self.etl-text(:TAG<MergedReferenceCode>,                      :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'MergedReferenceCode');
    $!SystemFirmware                                    = self.etl-text(:TAG<SystemFirmware>,                           :xml($xml-ManagedSystem))                                                   if self.attribute-is-accessed(self.^name, 'SystemFirmware');
    if self.attribute-is-accessed(self.^name, 'EnergyManagementConfiguration') {
        my $xml-EnergyManagementConfiguration           = self.etl-branch(:TAG<EnergyManagementConfiguration>,          :xml($xml-ManagedSystem));
        $!EnergyManagementConfiguration                 = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::EnergyManagementConfiguration.new(:$!config, :xml($xml-EnergyManagementConfiguration));
    }
    $!IsPowerVMManagementMaster                         = self.etl-text(:TAG<IsPowerVMManagementMaster>,                    :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'IsPowerVMManagementMaster');
    $!IsClassicHMCManagement                            = self.etl-text(:TAG<IsClassicHMCManagement>,                       :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'IsClassicHMCManagement');
    $!IsPowerVMManagementWithoutMaster                  = self.etl-text(:TAG<IsPowerVMManagementWithoutMaster>,             :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'IsPowerVMManagementWithoutMaster');
    $!IsManagementPartitionPowerVMManagementMaster      = self.etl-text(:TAG<IsManagementPartitionPowerVMManagementMaster>, :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'IsManagementPartitionPowerVMManagementMaster');
    $!IsHMCPowerVMManagementMaster                      = self.etl-text(:TAG<IsHMCPowerVMManagementMaster>,                 :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'IsHMCPowerVMManagementMaster');
    $!IsNotPowerVMManagementMaster                      = self.etl-text(:TAG<IsNotPowerVMManagementMaster>,                 :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'IsNotPowerVMManagementMaster');
    $!IsPowerVMManagementNormalMaster                   = self.etl-text(:TAG<IsPowerVMManagementNormalMaster>,              :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'IsPowerVMManagementNormalMaster');
    $!IsPowerVMManagementPersistentMaster               = self.etl-text(:TAG<IsPowerVMManagementPersistentMaster>,          :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'IsPowerVMManagementPersistentMaster');
    $!IsPowerVMManagementTemporaryMaster                = self.etl-text(:TAG<IsPowerVMManagementTemporaryMaster>,           :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'IsPowerVMManagementTemporaryMaster');
    $!IsPowerVMManagementPartitionEnabled               = self.etl-text(:TAG<IsPowerVMManagementPartitionEnabled>,          :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'IsPowerVMManagementPartitionEnabled');
    $!SystemType                                        = self.etl-text(:TAG<SystemType>,                                   :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'SystemType');
    $!ProcessorThrottling                               = self.etl-text(:TAG<ProcessorThrottling>,                          :xml($xml-ManagedSystem))                                               if self.attribute-is-accessed(self.^name, 'ProcessorThrottling');
    $!LogicalPartitions                                 = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::LogicalPartitions.new(:$!config, :Managed-System-Id($!id))              if self.attribute-is-accessed(self.^name, 'LogicalPartitions');
    $!VirtualIOServers                                  = Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::VirtualIOServers.new(:$!config, :Managed-System-Id($!id))               if self.attribute-is-accessed(self.^name, 'VirtualIOServers');
    $!initialized                                       = True;
    $!xml                                               = Nil;
    self.config.diag.post:                              sprintf("%-20s %10s: %11s", self.^name.subst(/^.+'::'(.+)$/, {$0}), 'INITIALIZE', sprintf("%.3f", now - $init-start)) if %*ENV<HIPH_INIT>;
    self;
}

=finish
