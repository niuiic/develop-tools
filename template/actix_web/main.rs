use actix_web::{get, web, App, HttpServer, Responder};

#[get("/mock/{req}")]
async fn greet(req: web::Path<String>) -> impl Responder {
    format!("{req}!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new().service(greet)
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
