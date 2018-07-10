import Vapor

final class UserController {
    
    var calls: Int = 0
    
    func list(_ req: Request) throws -> Future<View> {
        return User.query(on: req).all().flatMap { users in
            let data = ["userlist" : users]
            return try req.view().render("crud", data)
        }
    }
    
    func json(_ req: Request) throws -> Future<[User]> {
        let params = req.parameters.values
        print(params.map { $0.value }.first!)
        return User.self.query(on: req).all()
        
    }
    
    func create(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req).map {_ in
                return req.redirect(to: "/users")
            }
        }
    }
    
    func update(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(User.self).flatMap { user in
            return try req.content.decode(UserForm.self).flatMap { userForm in //<---------------------------- Pull user by name
                user.username = userForm.username
                print(user.id!)
                return user.save(on: req).map { _ in
                    return req.redirect(to: "/users")
                }
            }
        }
    }
    
    func delete(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req).map {_ in
                return req.redirect(to: "/users")
            }
        }
    }
}

struct UserForm: Content {
    var username: String
}
