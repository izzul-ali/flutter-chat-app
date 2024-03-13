// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'cfaace538dc0d411463e6312d21a12a573e36aca';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = Provider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRepositoryRef = ProviderRef<ChatRepository>;
String _$chatRoomsHash() => r'93032b578e6c1524b9a88d3c6286f64405422c59';

/// See also [chatRooms].
@ProviderFor(chatRooms)
final chatRoomsProvider = AutoDisposeStreamProvider<List<ChatRoom>>.internal(
  chatRooms,
  name: r'chatRoomsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatRoomsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRoomsRef = AutoDisposeStreamProviderRef<List<ChatRoom>>;
String _$messagesListHash() => r'f7ae6b48d34e28e0328d683d30ce86bdbe2ffd5a';

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

/// See also [messagesList].
@ProviderFor(messagesList)
const messagesListProvider = MessagesListFamily();

/// See also [messagesList].
class MessagesListFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [messagesList].
  const MessagesListFamily();

  /// See also [messagesList].
  MessagesListProvider call(
    String? chatroomId,
    String senderId,
    String receiverId,
  ) {
    return MessagesListProvider(
      chatroomId,
      senderId,
      receiverId,
    );
  }

  @override
  MessagesListProvider getProviderOverride(
    covariant MessagesListProvider provider,
  ) {
    return call(
      provider.chatroomId,
      provider.senderId,
      provider.receiverId,
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
  String? get name => r'messagesListProvider';
}

/// See also [messagesList].
class MessagesListProvider extends AutoDisposeStreamProvider<List<Message>> {
  /// See also [messagesList].
  MessagesListProvider(
    String? chatroomId,
    String senderId,
    String receiverId,
  ) : this._internal(
          (ref) => messagesList(
            ref as MessagesListRef,
            chatroomId,
            senderId,
            receiverId,
          ),
          from: messagesListProvider,
          name: r'messagesListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messagesListHash,
          dependencies: MessagesListFamily._dependencies,
          allTransitiveDependencies:
              MessagesListFamily._allTransitiveDependencies,
          chatroomId: chatroomId,
          senderId: senderId,
          receiverId: receiverId,
        );

  MessagesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatroomId,
    required this.senderId,
    required this.receiverId,
  }) : super.internal();

  final String? chatroomId;
  final String senderId;
  final String receiverId;

  @override
  Override overrideWith(
    Stream<List<Message>> Function(MessagesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MessagesListProvider._internal(
        (ref) => create(ref as MessagesListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatroomId: chatroomId,
        senderId: senderId,
        receiverId: receiverId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Message>> createElement() {
    return _MessagesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessagesListProvider &&
        other.chatroomId == chatroomId &&
        other.senderId == senderId &&
        other.receiverId == receiverId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatroomId.hashCode);
    hash = _SystemHash.combine(hash, senderId.hashCode);
    hash = _SystemHash.combine(hash, receiverId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MessagesListRef on AutoDisposeStreamProviderRef<List<Message>> {
  /// The parameter `chatroomId` of this provider.
  String? get chatroomId;

  /// The parameter `senderId` of this provider.
  String get senderId;

  /// The parameter `receiverId` of this provider.
  String get receiverId;
}

class _MessagesListProviderElement
    extends AutoDisposeStreamProviderElement<List<Message>>
    with MessagesListRef {
  _MessagesListProviderElement(super.provider);

  @override
  String? get chatroomId => (origin as MessagesListProvider).chatroomId;
  @override
  String get senderId => (origin as MessagesListProvider).senderId;
  @override
  String get receiverId => (origin as MessagesListProvider).receiverId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
