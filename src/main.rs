use tokio::time::{sleep, Duration};

async fn background_task()
{
    sleep(Duration::from_secs(1)).await;
    println!("Hello world from asynchronous Rust!");
}

#[tokio::main]
async fn main() {
    let task = tokio::spawn(background_task());
    sleep(Duration::from_secs(2)).await;
    task.await.unwrap();
}
