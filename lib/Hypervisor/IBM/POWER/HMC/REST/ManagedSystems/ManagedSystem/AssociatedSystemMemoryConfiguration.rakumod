need    Hypervisor::IBM::POWER::HMC::REST::Config;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Analyze;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Dump;
need    Hypervisor::IBM::POWER::HMC::REST::Config::Optimize;
use     Hypervisor::IBM::POWER::HMC::REST::Config::Traits;
need    Hypervisor::IBM::POWER::HMC::REST::ETL::XML;
unit    class Hypervisor::IBM::POWER::HMC::REST::ManagedSystems::ManagedSystem::AssociatedSystemMemoryConfiguration:api<1>:auth<Mark Devine (mark@markdevine.com)>
            does Hypervisor::IBM::POWER::HMC::REST::Config::Analyze
            does Hypervisor::IBM::POWER::HMC::REST::Config::Dump
            does Hypervisor::IBM::POWER::HMC::REST::Config::Optimize
            does Hypervisor::IBM::POWER::HMC::REST::ETL::XML;

my      Bool                                        $names-checked  = False;
my      Bool                                        $analyzed       = False;
my      Lock                                        $lock           = Lock.new;
has     Hypervisor::IBM::POWER::HMC::REST::Config   $.config        is required;
has     Bool                                        $.initialized   = False;
has     Str                                         @.AllowedHardwarePageTableRations                               is conditional-initialization-attribute;
has     Str                                         $.AllowedMemoryDeduplicationTableRatios                         is conditional-initialization-attribute;
has     Str                                         $.AllowedMemoryRegionSize                                       is conditional-initialization-attribute;
has     Str                                         $.ConfigurableHugePages                                         is conditional-initialization-attribute;
has     Str                                         $.ConfigurableSystemMemory                                      is conditional-initialization-attribute;
has     Str                                         $.ConfiguredMirroredMemory                                      is conditional-initialization-attribute;
has     Str                                         $.CurrentAvailableHugePages                                     is conditional-initialization-attribute;
has     Str                                         $.CurrentAvailableMirroredMemory                                is conditional-initialization-attribute;
has     Str                                         $.CurrentAvailableSystemMemory                                  is conditional-initialization-attribute;
has     Str                                         $.CurrentLogicalMemoryBlockSize                                 is conditional-initialization-attribute;
has     Str                                         $.CurrentMemoryMirroringMode                                    is conditional-initialization-attribute;
has     Str                                         $.CurrentMirroredMemory                                         is conditional-initialization-attribute;
has     Str                                         $.DeconfiguredSystemMemory                                      is conditional-initialization-attribute;
has     Str                                         $.DefaultHardwarePageTableRatio                                 is conditional-initialization-attribute;
has     Str                                         $.DefaultHardwarePagingTableRatioForDedicatedMemoryPartition    is conditional-initialization-attribute;
has     Str                                         $.DefaultMemoryDeduplicationTableRatio                          is conditional-initialization-attribute;
has     Str                                         $.HugePageCount                                                 is conditional-initialization-attribute;
has     Str                                         $.HugePageSize                                                  is conditional-initialization-attribute;
has     Str                                         $.InstalledSystemMemory                                         is conditional-initialization-attribute;
has     Str                                         $.MaximumHugePages                                              is conditional-initialization-attribute;
has     Str                                         $.MaximumMemoryPoolCount                                        is conditional-initialization-attribute;
has     Str                                         $.MaximumMirroredMemoryDefragmented                             is conditional-initialization-attribute;
has     Str                                         $.MaximumPagingVirtualIOServersPerSharedMemoryPool              is conditional-initialization-attribute;
has     Str                                         $.MemoryDefragmentationState                                    is conditional-initialization-attribute;
has     Str                                         $.MemoryMirroringState                                          is conditional-initialization-attribute;
has     Str                                         $.MemoryRegionSize                                              is conditional-initialization-attribute;
has     Str                                         $.MemoryUsedByHypervisor                                        is conditional-initialization-attribute;
has     Str                                         $.MirrorableMemoryWithDefragmentation                           is conditional-initialization-attribute;
has     Str                                         $.MirrorableMemoryWithoutDefragmentation                        is conditional-initialization-attribute;
has     Str                                         $.MirroredMemoryUsedByHypervisor                                is conditional-initialization-attribute;
has     Str                                         $.PendingAvailableHugePages                                     is conditional-initialization-attribute;
has     Str                                         $.PendingAvailableSystemMemory                                  is conditional-initialization-attribute;
has     Str                                         $.PendingLogicalMemoryBlockSize                                 is conditional-initialization-attribute;
has     Str                                         $.PendingMemoryMirroringMode                                    is conditional-initialization-attribute;
has     Str                                         $.PendingMemoryRegionSize                                       is conditional-initialization-attribute;
has     Str                                         $.RequestedHugePages                                            is conditional-initialization-attribute;
has     Str                                         $.TemporaryMemoryForLogicalPartitionMobilityInUse               is conditional-initialization-attribute;
has     Str                                         $.DefaultPhysicalPageTableRatio                                 is conditional-initialization-attribute;
has     Str                                         @.AllowedPhysicalPageTableRatios                                is conditional-initialization-attribute;
has     Str                                         $.PermanentSystemMemory                                         is conditional-initialization-attribute;
has     Str                                         $.CurrentAssignedMemoryToPartitions                             is conditional-initialization-attribute;

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
    return self                                                     if $!initialized;
    self.config.diag.post:                                          self.^name ~ '::' ~ &?ROUTINE.name if %*ENV<HIPH_METHOD>;
    @!AllowedHardwarePageTableRations                               = self.etl-texts(:TAG<AllowedHardwarePageTableRations>,                             :$!xml) if self.attribute-is-accessed(self.^name, 'AllowedHardwarePageTableRations');
    $!AllowedMemoryDeduplicationTableRatios                         = self.etl-text(:TAG<AllowedMemoryDeduplicationTableRatios>,                        :$!xml) if self.attribute-is-accessed(self.^name, 'AllowedMemoryDeduplicationTableRatios');
    $!AllowedMemoryRegionSize                                       = self.etl-text(:TAG<AllowedMemoryRegionSize>,                                      :$!xml) if self.attribute-is-accessed(self.^name, 'AllowedMemoryRegionSize');
    $!ConfigurableHugePages                                         = self.etl-text(:TAG<ConfigurableHugePages>,                                        :$!xml) if self.attribute-is-accessed(self.^name, 'ConfigurableHugePages');
    $!ConfigurableSystemMemory                                      = self.etl-text(:TAG<ConfigurableSystemMemory>,                                     :$!xml) if self.attribute-is-accessed(self.^name, 'ConfigurableSystemMemory');
    $!ConfiguredMirroredMemory                                      = self.etl-text(:TAG<ConfiguredMirroredMemory>,                                     :$!xml) if self.attribute-is-accessed(self.^name, 'ConfiguredMirroredMemory');
    $!CurrentAvailableHugePages                                     = self.etl-text(:TAG<CurrentAvailableHugePages>,                                    :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentAvailableHugePages');
    $!CurrentAvailableMirroredMemory                                = self.etl-text(:TAG<CurrentAvailableMirroredMemory>,                               :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentAvailableMirroredMemory');
    $!CurrentAvailableSystemMemory                                  = self.etl-text(:TAG<CurrentAvailableSystemMemory>,                                 :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentAvailableSystemMemory');
    $!CurrentLogicalMemoryBlockSize                                 = self.etl-text(:TAG<CurrentLogicalMemoryBlockSize>,                                :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentLogicalMemoryBlockSize');
    $!CurrentMemoryMirroringMode                                    = self.etl-text(:TAG<CurrentMemoryMirroringMode>,                                   :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentMemoryMirroringMode');
    $!CurrentMirroredMemory                                         = self.etl-text(:TAG<CurrentMirroredMemory>,                                        :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentMirroredMemory');
    $!DeconfiguredSystemMemory                                      = self.etl-text(:TAG<DeconfiguredSystemMemory>,                                     :$!xml) if self.attribute-is-accessed(self.^name, 'DeconfiguredSystemMemory');
    $!DefaultHardwarePageTableRatio                                 = self.etl-text(:TAG<DefaultHardwarePageTableRatio>,                                :$!xml) if self.attribute-is-accessed(self.^name, 'DefaultHardwarePageTableRatio');
    $!DefaultHardwarePagingTableRatioForDedicatedMemoryPartition    = self.etl-text(:TAG<DefaultHardwarePagingTableRatioForDedicatedMemoryPartition>,   :$!xml) if self.attribute-is-accessed(self.^name, 'DefaultHardwarePagingTableRatioForDedicatedMemoryPartition');
    $!DefaultMemoryDeduplicationTableRatio                          = self.etl-text(:TAG<DefaultMemoryDeduplicationTableRatio>,                         :$!xml) if self.attribute-is-accessed(self.^name, 'DefaultMemoryDeduplicationTableRatio');
    $!HugePageCount                                                 = self.etl-text(:TAG<HugePageCount>,                                                :$!xml) if self.attribute-is-accessed(self.^name, 'HugePageCount');
    $!HugePageSize                                                  = self.etl-text(:TAG<HugePageSize>,                                                 :$!xml) if self.attribute-is-accessed(self.^name, 'HugePageSize');
    $!InstalledSystemMemory                                         = self.etl-text(:TAG<InstalledSystemMemory>,                                        :$!xml) if self.attribute-is-accessed(self.^name, 'InstalledSystemMemory');
    $!MaximumHugePages                                              = self.etl-text(:TAG<MaximumHugePages>,                                             :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumHugePages');
    $!MaximumMemoryPoolCount                                        = self.etl-text(:TAG<MaximumMemoryPoolCount>,                                       :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumMemoryPoolCount');
    $!MaximumMirroredMemoryDefragmented                             = self.etl-text(:TAG<MaximumMirroredMemoryDefragmented>,                            :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumMirroredMemoryDefragmented');
    $!MaximumPagingVirtualIOServersPerSharedMemoryPool              = self.etl-text(:TAG<MaximumPagingVirtualIOServersPerSharedMemoryPool>,             :$!xml) if self.attribute-is-accessed(self.^name, 'MaximumPagingVirtualIOServersPerSharedMemoryPool');
    $!MemoryDefragmentationState                                    = self.etl-text(:TAG<MemoryDefragmentationState>,                                   :$!xml) if self.attribute-is-accessed(self.^name, 'MemoryDefragmentationState');
    $!MemoryMirroringState                                          = self.etl-text(:TAG<MemoryMirroringState>,                                         :$!xml) if self.attribute-is-accessed(self.^name, 'MemoryMirroringState');
    $!MemoryRegionSize                                              = self.etl-text(:TAG<MemoryRegionSize>,                                             :$!xml) if self.attribute-is-accessed(self.^name, 'MemoryRegionSize');
    $!MemoryUsedByHypervisor                                        = self.etl-text(:TAG<MemoryUsedByHypervisor>,                                       :$!xml) if self.attribute-is-accessed(self.^name, 'MemoryUsedByHypervisor');
    $!MirrorableMemoryWithDefragmentation                           = self.etl-text(:TAG<MirrorableMemoryWithDefragmentation>,                          :$!xml) if self.attribute-is-accessed(self.^name, 'MirrorableMemoryWithDefragmentation');
    $!MirrorableMemoryWithoutDefragmentation                        = self.etl-text(:TAG<MirrorableMemoryWithoutDefragmentation>,                       :$!xml) if self.attribute-is-accessed(self.^name, 'MirrorableMemoryWithoutDefragmentation');
    $!MirroredMemoryUsedByHypervisor                                = self.etl-text(:TAG<MirroredMemoryUsedByHypervisor>,                               :$!xml) if self.attribute-is-accessed(self.^name, 'MirroredMemoryUsedByHypervisor');
    $!PendingAvailableHugePages                                     = self.etl-text(:TAG<PendingAvailableHugePages>,                                    :$!xml) if self.attribute-is-accessed(self.^name, 'PendingAvailableHugePages');
    $!PendingAvailableSystemMemory                                  = self.etl-text(:TAG<PendingAvailableSystemMemory>,                                 :$!xml) if self.attribute-is-accessed(self.^name, 'PendingAvailableSystemMemory');
    $!PendingLogicalMemoryBlockSize                                 = self.etl-text(:TAG<PendingLogicalMemoryBlockSize>,                                :$!xml) if self.attribute-is-accessed(self.^name, 'PendingLogicalMemoryBlockSize');
    $!PendingMemoryMirroringMode                                    = self.etl-text(:TAG<PendingMemoryMirroringMode>,                                   :$!xml) if self.attribute-is-accessed(self.^name, 'PendingMemoryMirroringMode');
    $!PendingMemoryRegionSize                                       = self.etl-text(:TAG<PendingMemoryRegionSize>,                                      :$!xml) if self.attribute-is-accessed(self.^name, 'PendingMemoryRegionSize');
    $!RequestedHugePages                                            = self.etl-text(:TAG<RequestedHugePages>,                                           :$!xml) if self.attribute-is-accessed(self.^name, 'RequestedHugePages');
    $!TemporaryMemoryForLogicalPartitionMobilityInUse               = self.etl-text(:TAG<TemporaryMemoryForLogicalPartitionMobilityInUse>,              :$!xml) if self.attribute-is-accessed(self.^name, 'TemporaryMemoryForLogicalPartitionMobilityInUse');
    $!DefaultPhysicalPageTableRatio                                 = self.etl-text(:TAG<DefaultPhysicalPageTableRatio>,                                :$!xml) if self.attribute-is-accessed(self.^name, 'DefaultPhysicalPageTableRatio');
    @!AllowedPhysicalPageTableRatios                                = self.etl-texts(:TAG<AllowedPhysicalPageTableRatios>,                              :$!xml) if self.attribute-is-accessed(self.^name, 'AllowedPhysicalPageTableRatios');
    $!PermanentSystemMemory                                         = self.etl-text(:TAG<PermanentSystemMemory>,                                        :$!xml) if self.attribute-is-accessed(self.^name, 'PermanentSystemMemory');
    $!CurrentAssignedMemoryToPartitions                             = self.etl-text(:TAG<CurrentAssignedMemoryToPartitions>,                            :$!xml) if self.attribute-is-accessed(self.^name, 'CurrentAssignedMemoryToPartitions');
    $!xml                                                           = Nil;
    $!initialized                                                   = True;
    self;
}

=finish
