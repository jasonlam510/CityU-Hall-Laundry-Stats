// Initialize database and create timeseries collection for machine status
// This script runs automatically when MongoDB container starts for the first time

// Switch to the database (creates it if it doesn't exist)
db = db.getSiblingDB('cityu_hall_laundry');

// Create the timeseries collection with specified configuration
db.createCollection('machine_status', {
  timeseries: {
    timeField: 'ts',
    metaField: 'meta',          
    granularity: 'minutes'      
  }
});

// Create indexes for better query performance
db.machine_status.createIndex({ 'ts': 1, 'meta.machineId': 1 });
db.machine_status.createIndex({ 'meta.hallCode': 1 });

print('Database "cityu_hall_laundry" initialized');
print('Timeseries collection "machine_status" created successfully');

