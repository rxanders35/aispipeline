use anyhow::Result;
use scraper::Html;

struct PageData;

async fn process_html(url: &str) -> Result<Html> {
    let body = reqwest::get(url).await?.text().await?;
    let html = Html::parse_document(&body);
    return Ok(html);
}

#[tokio::main]
async fn main() -> Result<()> {
    let url = "https://web.ais.dk/aisdata/";
    let html = process_html(url).await?;
    Ok(())
}
