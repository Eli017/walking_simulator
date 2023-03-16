// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journeys_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journeysRepositoryHash() =>
    r'2b2ca3f69409ab3feb11d88583d87bca6b39c9ce';

/// See also [journeysRepository].
@ProviderFor(journeysRepository)
final journeysRepositoryProvider = Provider<JourneysRepository>.internal(
  journeysRepository,
  name: r'journeysRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journeysRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef JourneysRepositoryRef = ProviderRef<JourneysRepository>;
String _$journeysQueryHash() => r'b8f2ed77869fc8bc193478925533529ce9348796';

/// See also [journeysQuery].
@ProviderFor(journeysQuery)
final journeysQueryProvider = AutoDisposeProvider<Query<Journey>>.internal(
  journeysQuery,
  name: r'journeysQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journeysQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef JourneysQueryRef = AutoDisposeProviderRef<Query<Journey>>;
String _$journeyStreamHash() => r'66d2d0c486e091baceac480f4a1fd2649053014d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef JourneyStreamRef = AutoDisposeStreamProviderRef<Journey>;

/// See also [journeyStream].
@ProviderFor(journeyStream)
const journeyStreamProvider = JourneyStreamFamily();

/// See also [journeyStream].
class JourneyStreamFamily extends Family<AsyncValue<Journey>> {
  /// See also [journeyStream].
  const JourneyStreamFamily();

  /// See also [journeyStream].
  JourneyStreamProvider call(
    String jobId,
  ) {
    return JourneyStreamProvider(
      jobId,
    );
  }

  @override
  JourneyStreamProvider getProviderOverride(
    covariant JourneyStreamProvider provider,
  ) {
    return call(
      provider.jobId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'journeyStreamProvider';
}

/// See also [journeyStream].
class JourneyStreamProvider extends AutoDisposeStreamProvider<Journey> {
  /// See also [journeyStream].
  JourneyStreamProvider(
    this.jobId,
  ) : super.internal(
          (ref) => journeyStream(
            ref,
            jobId,
          ),
          from: journeyStreamProvider,
          name: r'journeyStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$journeyStreamHash,
          dependencies: JourneyStreamFamily._dependencies,
          allTransitiveDependencies:
              JourneyStreamFamily._allTransitiveDependencies,
        );

  final String jobId;

  @override
  bool operator ==(Object other) {
    return other is JourneyStreamProvider && other.jobId == jobId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, jobId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
