import UIKit
import WebKit
import SnapKit

class MainViewController: UIViewController {

    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let script = WKUserScript(source: hideReelsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(script)

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        return webView
    }()

    private let hideReelsScript = """
    var style = document.createElement('style');
    style.innerHTML = `
        /* Hide Reels nav button */
        a[href="/reels/"], a[href*="/reels"], nav a[aria-label="Reels"], div[role="menuitem"][aria-label="Reels"],
        header a[href*="reel"], svg path[d*="M12.225"], div[data-bloks-id*="reels"],
        li a[href*="reels"], div[data-bloks-id*="reels_tray"] {
            display: none !important;
        }
        /* Rescale remaining nav items to be equidistant */
        nav[role="navigation"] ul {
            display: flex !important;
            justify-content: space-evenly !important;
        }
        nav[role="navigation"] ul li {
            flex: 1 !important;
            text-align: center !important;
        }
        /* Debug overlay */
        #debug-overlay {
            position: fixed;
            top: 50px;
            left: 10px;
            background: purple;
            color: white;
            padding: 10px;
            z-index: 999999;
            font-size: 10px;
            border-radius: 5px;
            max-width: 300px;
        }
    `;
    document.head.appendChild(style);

    // Debug overlay
    var debugDiv = document.createElement('div');
    debugDiv.id = 'debug-overlay';
    debugDiv.textContent = 'init';
    document.body.appendChild(debugDiv);

    // Update debug info
    setInterval(function() {
        var path = window.location.pathname;
        var articleCount = document.querySelectorAll('article').length;
        var divsWithImg = document.querySelectorAll('div img[src*="instagram"], div img[src*="cdninstagram"]').length;
        var liCount = document.querySelectorAll('li[role="presentation"]').length;
        var mainDivs = document.querySelectorAll('main > div > div').length;
        debugDiv.textContent = 'URL: ' + path + ' | articles: ' + articleCount + ' | imgs: ' + divsWithImg + ' | li: ' + liCount + ' | mainDivs: ' + mainDivs;
    }, 100);

    // Send user back to chat
    function returnToChat() {
        var closeBtn = document.querySelector('button[aria-label="Close"], button[aria-label="Back"], header button');
        if (closeBtn) {
            closeBtn.click();
        } else {
            window.location.href = '/direct/inbox/';
        }
    }

    // Block scrolling when video appears in DM context
    setInterval(function() {
        var hasVideo = document.querySelector('video') !== null;
        var inDM = window.location.pathname.includes('/direct/');

        if (hasVideo && inDM) {
            document.body.style.overflow = 'hidden';
            document.documentElement.style.overflow = 'hidden';
        }
    }, 100);

    // Add blocking events whenever video is present
    setInterval(function() {
        if (document.querySelector('video') && window.location.pathname.includes('/direct/')) {
            // Block touchmove
            document.addEventListener('touchmove', function(e) {
                e.preventDefault();
                returnToChat();
            }, { passive: false, capture: true });

            // Block wheel
            document.addEventListener('wheel', function(e) {
                e.preventDefault();
                returnToChat();
            }, { passive: false, capture: true });

            // Block click on background (not on interactive elements)
            document.addEventListener('click', function(e) {
                var target = e.target;
                if (!target.closest('button, a, [role="button"], input, textarea')) {
                    e.preventDefault();
                    returnToChat();
                }
            }, { passive: false, capture: true });
        }
    }, 200);

    // Block posts on explore/search page ONLY
    function blockExplorePosts() {
        var path = window.location.pathname;
        // Only block on explore and search pages, NOT home
        if ((path.includes('/explore/') || path.includes('/search/')) && !path.includes('/direct/')) {
            // Hide article posts
            var posts = document.querySelectorAll('article');
            posts.forEach(function(post) {
                post.style.display = 'none';
            });

            // Hide divs with instagram images (post thumbnails) - but not search input
            var postThumbs = document.querySelectorAll('div img[src*="instagram"], div img[src*="cdninstagram"]');
            postThumbs.forEach(function(img) {
                var parent = img.closest('div');
                if (parent && !parent.querySelector('input')) {
                    parent.style.display = 'none';
                }
            });
        }
    }

    setInterval(blockExplorePosts, 200);

    var observer = new MutationObserver(function() {
        // Hide any dynamically loaded reels elements
        var reels = document.querySelectorAll('a[href="/reels/"], a[href*="/reels"], a[aria-label="Reels"], nav a[aria-label="Reels"], div[role="menuitem"][aria-label="Reels"], li a[href*="reels"]');
        reels.forEach(function(el) {
            el.style.display = 'none';
            el.parentElement ? el.parentElement.style.display = 'none' : null;
        });
        // Rescale nav items
        var nav = document.querySelector('nav[role="navigation"] ul');
        if (nav) {
            nav.style.display = 'flex';
            nav.style.justifyContent = 'space-evenly';
        }
    });
    observer.observe(document.body, { childList: true, subtree: true });
    """

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progressTintColor = UIColor(red: 225/255, green: 48/255, blue: 108/255, alpha: 1)
        progressView.trackTintColor = .clear
        return progressView
    }()



    private var progressObservation: NSKeyValueObservation?

    private lazy var statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var bufferView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    override var prefersStatusBarHidden: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
        setupUI()
        loadInstagram()
        setupProgressObserver()
    }

    private func setupUI() {
        view.backgroundColor = .black

        view.addSubview(statusBar)
        view.addSubview(bufferView)
        view.addSubview(webView)
        view.addSubview(progressView)

        statusBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.safeAreaInsets.top)
        }

        bufferView.snp.makeConstraints { make in
            make.top.equalTo(statusBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        webView.snp.makeConstraints { make in
            make.top.equalTo(bufferView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupProgressObserver() {
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            let progress = Float(webView.estimatedProgress)
            self?.progressView.setProgress(progress, animated: true)
            self?.progressView.isHidden = progress >= 1.0
        }
    }

    private func loadInstagram() {
        guard let url = URL(string: "https://www.instagram.com") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension MainViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        progressView.setProgress(0.1, animated: false)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
