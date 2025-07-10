class AudioModel {
  final String id;
  final String name;
  final String path;
  final String? artist;
  final String? album;
  final Duration? duration;
  final double? size;
  final DateTime createdAt;
  final DateTime modifiedAt;

  AudioModel({
    required this.id,
    required this.name,
    required this.path,
    this.artist,
    this.album,
    this.duration,
    this.size,
    required this.createdAt,
    required this.modifiedAt,
  });

  // 从JSON创建对象
  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      artist: json['artist'] as String?,
      album: json['album'] as String?,
      duration: json['duration'] != null 
          ? Duration(milliseconds: json['duration'] as int)
          : null,
      size: json['size'] as double?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'artist': artist,
      'album': album,
      'duration': duration?.inMilliseconds,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }

  // 复制对象
  AudioModel copyWith({
    String? id,
    String? name,
    String? path,
    String? artist,
    String? album,
    Duration? duration,
    double? size,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return AudioModel(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'AudioModel(id: $id, name: $name, path: $path)';
  }
} 