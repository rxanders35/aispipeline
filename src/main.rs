use anyhow::Result;
use reqwest::Client;
use scraper::{Html, Selector};

struct PageData;

async fn process_html(body: String) -> Result<Html> {
    let html = Html::parse_document(&body);
    let row_selector = Selector::parse("tr").unwrap();
    let link_selector = Selector::parse("a[href]").unwrap();
    let td_selector = Selector::parse("td[align=\"right\"]").unwrap();

    let mut res: Vec<_> = Vec::new();

    for row in html.select(&row_selector) {
        let link = row
            .select(&row_selector)
            .next()
            .and_then(|elem| elem.value().attr("href"))
            .filter(|href| href.ends_with(".zip"));
    }

    return Ok(html);
}

#[tokio::main]
async fn main() -> Result<()> {
    let url = "https://web.ais.dk/aisdata/";
    let client = Client::new();
    let response = client.get(url).send().await;
    let body = response.unwrap().text().await.unwrap();
    let html = process_html(body);
    Ok(())
}
