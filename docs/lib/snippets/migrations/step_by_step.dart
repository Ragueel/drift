import 'dart:math' as math;

import 'package:drift/drift.dart';

import 'migrations.dart';

// #docregion stepbystep
// This file was generated by `drift_dev schema steps drift_schemas/ lib/database/schema_versions.dart`
import 'schema_versions.dart';

// #enddocregion stepbystep

class StepByStep {
  // #docregion stepbystep
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          // we added the dueDate property in the change from version 1 to
          // version 2
          await m.addColumn(schema.todos, schema.todos.dueDate);
        },
        from2To3: (m, schema) async {
          // we added the priority property in the change from version 1 or 2
          // to version 3
          await m.addColumn(schema.todos, schema.todos.priority);
        },
      ),
    );
  }
  // #enddocregion stepbystep
}

extension StepByStep2 on GeneratedDatabase {
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      // #docregion stepbystep2
      onUpgrade: (m, from, to) async {
        // Run migration steps without foreign keys and re-enable them later
        // (https://drift.simonbinder.eu/docs/advanced-features/migrations/#tips)
        await customStatement('PRAGMA foreign_keys = OFF');

        await m.runMigrationSteps(
          from: from,
          to: to,
          steps: migrationSteps(
            from1To2: (m, schema) async {
              // we added the dueDate property in the change from version 1 to
              // version 2
              await m.addColumn(schema.todos, schema.todos.dueDate);
            },
            from2To3: (m, schema) async {
              // we added the priority property in the change from version 1 or 2
              // to version 3
              await m.addColumn(schema.todos, schema.todos.priority);
            },
          ),
        );

        if (kDebugMode) {
          // Fail if the migration broke foreign keys
          final wrongForeignKeys =
              await customSelect('PRAGMA foreign_key_check').get();
          assert(wrongForeignKeys.isEmpty,
              '${wrongForeignKeys.map((e) => e.data)}');
        }

        await customStatement('PRAGMA foreign_keys = ON;');
      },
      // #enddocregion stepbystep2
    );
  }
}

extension StepByStep3 on MyDatabase {
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      // #docregion stepbystep3
      onUpgrade: (m, from, to) async {
        // Run migration steps without foreign keys and re-enable them later
        // (https://drift.simonbinder.eu/docs/advanced-features/migrations/#tips)
        await customStatement('PRAGMA foreign_keys = OFF');

        // Manually running migrations up to schema version 2, after which we've
        // enabled step-by-step migrations.
        if (from < 2) {
          // we added the dueDate property in the change from version 1 to
          // version 2 - before switching to step-by-step migrations.
          await m.addColumn(todos, todos.dueDate);
        }

        // At this point, we should be migrated to schema 3. For future schema
        // changes, we will "start" at schema 3.
        await m.runMigrationSteps(
          from: math.max(2, from),
          to: to,
          // ignore: missing_required_argument
          steps: migrationSteps(
            from2To3: (m, schema) async {
              // we added the priority property in the change from version 1 or
              // 2 to version 3
              await m.addColumn(schema.todos, schema.todos.priority);
            },
          ),
        );

        if (kDebugMode) {
          // Fail if the migration broke foreign keys
          final wrongForeignKeys =
              await customSelect('PRAGMA foreign_key_check').get();
          assert(wrongForeignKeys.isEmpty,
              '${wrongForeignKeys.map((e) => e.data)}');
        }

        await customStatement('PRAGMA foreign_keys = ON;');
      },
      // #enddocregion stepbystep3
    );
  }
}