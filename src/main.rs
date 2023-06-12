#[macro_use] extern crate rocket;

use std::path::{Path, PathBuf};
use rocket::fs::NamedFile;
use rocket::response::status;

#[get("/")]
async fn index() -> Option<NamedFile> {
    NamedFile::open(Path::new("./static/index.html")).await.ok()
}

#[get("/<_..>")]
async fn index_route() -> Option<NamedFile> {
    NamedFile::open(Path::new("./static/index.html")).await.ok()
}

#[get("/static/<file..>")]
async fn files(file: PathBuf) -> Option<NamedFile> {
    NamedFile::open(Path::new("./static/").join(file)).await.ok()
}

#[get("/assets/<file..>")]
async fn assets(file: PathBuf) -> Option<NamedFile> {
    NamedFile::open(Path::new("./static/assets/").join(file)).await.ok()
}

#[post("/new_resume")]
async fn new_resume() -> status::Accepted<String> {
    status::Accepted(Some("Thank You!".to_string()))
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index, index_route, files, assets, new_resume])
}
