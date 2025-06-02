import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import '../models/emotion_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'feelomi.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Table des utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        preferences TEXT,
        is_active INTEGER DEFAULT 1
      )
    ''');

    // Table des entrées émotionnelles
    await db.execute('''
      CREATE TABLE emotion_entries (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        emotion_type TEXT NOT NULL,
        intensity INTEGER NOT NULL,
        notes TEXT,
        triggers TEXT NOT NULL,
        context_data TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Table des rappels
    await db.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        message TEXT,
        scheduled_time TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        frequency TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Index pour optimiser les requêtes
    await db.execute('''
      CREATE INDEX idx_emotion_entries_user_timestamp 
      ON emotion_entries (user_id, timestamp)
    ''');

    await db.execute('''
      CREATE INDEX idx_emotion_entries_emotion_type 
      ON emotion_entries (emotion_type)
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    // Gestion des migrations futures
    if (oldVersion < 2) {
      // Migrations pour version 2
    }
  }

  // Méthodes pour les utilisateurs
  Future<String> createUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final db = await database;
    final id = _generateId();
    final passwordHash = _hashPassword(password);
    final now = DateTime.now().toIso8601String();

    await db.insert('users', {
      'id': id,
      'email': email,
      'password_hash': passwordHash,
      'name': name,
      'created_at': now,
      'updated_at': now,
    });

    return id;
  }

  Future<Map<String, dynamic>?> authenticateUser(String email, String password) async {
    final db = await database;
    final passwordHash = _hashPassword(password);

    final result = await db.query(
      'users',
      where: 'email = ? AND password_hash = ? AND is_active = 1',
      whereArgs: [email, passwordHash],
    );

    return result.isNotEmpty ? result.first : null;
  }

  // Méthodes pour les entrées émotionnelles
  Future<void> insertEmotionEntry(EmotionEntry entry) async {
    final db = await database;
    
    await db.insert('emotion_entries', {
      'id': entry.id,
      'user_id': entry.userId,
      'timestamp': entry.timestamp.toIso8601String(),
      'emotion_type': entry.emotionType.toString().split('.').last,
      'intensity': entry.intensity,
      'notes': entry.notes,
      'triggers': jsonEncode(entry.triggers),
      'context_data': entry.contextData != null ? jsonEncode(entry.contextData) : null,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<EmotionEntry>> getEmotionEntries({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    final db = await database;
    
    String whereClause = 'user_id = ?';
    List<dynamic> whereArgs = [userId];

    if (startDate != null) {
      whereClause += ' AND timestamp >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      whereClause += ' AND timestamp <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    final result = await db.query(
      'emotion_entries',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return result.map((map) => _mapToEmotionEntry(map)).toList();
  }

  Future<EmotionAnalytics> getEmotionAnalytics({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final entries = await getEmotionEntries(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );

    return EmotionAnalytics.fromEntries(entries);
  }

  Future<void> deleteEmotionEntry(String id) async {
    final db = await database;
    await db.delete(
      'emotion_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateEmotionEntry(EmotionEntry entry) async {
    final db = await database;
    
    await db.update(
      'emotion_entries',
      {
        'emotion_type': entry.emotionType.toString().split('.').last,
        'intensity': entry.intensity,
        'notes': entry.notes,
        'triggers': jsonEncode(entry.triggers),
        'context_data': entry.contextData != null ? jsonEncode(entry.contextData) : null,
      },
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  // Méthodes utilitaires
  EmotionEntry _mapToEmotionEntry(Map<String, dynamic> map) {
    return EmotionEntry(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      emotionType: EmotionType.fromString(map['emotion_type'] as String),
      intensity: map['intensity'] as int,
      notes: map['notes'] as String?,
      triggers: List<String>.from(jsonDecode(map['triggers'] as String)),
      contextData: map['context_data'] != null 
          ? Map<String, dynamic>.from(jsonDecode(map['context_data'] as String))
          : null,
    );
  }

  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = (timestamp + DateTime.now().microsecond.toString()).hashCode;
    return '$timestamp$random';
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Nettoyage
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('emotion_entries');
      await txn.delete('reminders');
      await txn.delete('users');
    });
  }
}