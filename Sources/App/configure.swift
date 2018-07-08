import FluentSQLite
import Vapor
import Leaf

/// Called before your application initializes.
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    let myService = NIOServerConfig.default(port: 8003)
    services.register(myService)
    
    // Register the LeafProvider
    try services.register(LeafProvider()) // added
    
    // Register Fluent
    try services.register(FluentSQLiteProvider())
    
    // Set LeafRenderer as our preferred ViewRenderer
    config.prefer(LeafRenderer.self, for: ViewRenderer.self) // added
    
    // Initiate database service
    var databases = DatabasesConfig()
    try databases.add(database: SQLiteDatabase(storage: .memory), as: .sqlite)
    services.register(databases)
    
    // Register migration service to introduce model to database
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .sqlite) // adding things to migrations...
    services.register(migrations)

}

