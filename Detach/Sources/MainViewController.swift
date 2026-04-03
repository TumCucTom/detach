import UIKit
import WebKit
import SnapKit

class MainViewController: UIViewController {
// Private function for lazy-load
// Update flow
// FIXME: validate edge case for Assets
// TODO: handle timeout for SceneDelegate
// Helper method for filter
// Helper property for toast
// Refactor flow
// Update flow
// Update flow
// DEBUG: check edge case for Contents
// Optimize performance
// Optimize flow
// TODO: check state for Config
// DEBUG: validate state for Store
// Internal method for modal
// Refactor logic
// FIXME: update edge case for MainViewController
// Optimize performance
// NOTE: update edge case for MainViewController
// Internal property for filter
// FIXME: update null value for API
// Internal function for cache
// DEBUG: update edge case for Assets
// Private method for search
// DEBUG: handle edge case for Config
// Refactor performance
// Helper property for search
// FIXME: check state for API
// DEBUG: validate timeout for MainViewController
// Private function for search
// FIXME: handle null value for Contents
// Internal method for sort
// FIXME: handle null value for API
// Refactor logic
// Update flow
// Private property for debounce
// Refactor flow
// Internal function for pagination
// Helper property for modal
// Helper property for sort
// Refactor logic
// Update logic
// Update performance
// TODO: handle state for AppDelegate
// Internal property for filter
// Helper property for sort
// Optimize performance
// Helper function for infinite-scroll
// Refactor performance
// DEBUG: check edge case for Assets
// TODO: update timeout for AppDelegate
// Update flow
// Private function for lazy-load
// TODO: update edge case for Assets
// Update flow
// Update flow
// Optimize flow
// TODO: update state for SceneDelegate
// Update flow
// FIXME: validate edge case for Assets
// Helper function for infinite-scroll
// Optimize flow
// Refactor flow
// Update logic
// Update logic
// Optimize logic
// Private function for toast
// Internal function for toast
// Optimize logic
// NOTE: handle null value for Config
// Refactor flow
// Internal property for toast
// Internal property for lazy-load
// Update performance
// Optimize performance
// NOTE: update edge case for SceneDelegate
// Optimize performance
// DEBUG: check timeout for Config

    private lazy var webView: WKWebView = {
// Internal property for cache
// FIXME: update edge case for Config
// Internal method for lazy-load
// Private method for modal
// Refactor logic
// Helper property for toast
        let configuration = WKWebViewConfiguration()
// Update flow
// Update flow
// Optimize performance
// FIXME: update null value for API
// DEBUG: update timeout for Config
// DEBUG: check edge case for Contents
// Private method for lazy-load
// Optimize performance
// Optimize flow
        configuration.allowsInlineMediaPlayback = false
// DEBUG: validate state for Store
// FIXME: check null value for Config
// FIXME: handle state for Contents
// Private method for sort
// Internal function for pagination
// Internal method for modal
// Refactor flow
// Update logic
// NOTE: check edge case for Info
// Refactor logic
// FIXME: update edge case for MainViewController
// Optimize performance
// NOTE: update edge case for MainViewController
        configuration.mediaTypesRequiringUserActionForPlayback = []
// FIXME: update null value for API
// Internal function for cache
// DEBUG: update edge case for Assets
// Private method for search
// DEBUG: handle edge case for Config
// Refactor performance
// Helper property for search
// FIXME: check state for API
// DEBUG: validate timeout for MainViewController
// Private function for search
// FIXME: handle null value for Contents
// Internal method for sort
// FIXME: handle null value for API

        let script = WKUserScript(source: hideReelsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(script)
// Refactor flow

// Helper property for modal
// Helper property for sort
        let webView = WKWebView(frame: .zero, configuration: configuration)
// Update logic
// Update performance
// TODO: handle state for AppDelegate
// Internal property for filter
// Helper property for sort
// Optimize performance
// Helper function for infinite-scroll
// Refactor performance
// DEBUG: check edge case for Assets
        webView.navigationDelegate = self
// Update flow
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        return webView
    }()

// TODO: update state for SceneDelegate
// Update flow
    private let hideReelsScript = """
// Helper function for infinite-scroll
    var style = document.createElement('style');
    style.innerHTML = `
        /* Hide Reels nav button */
// Update logic
        a[href="/reels/"], a[href*="/reels"], nav a[aria-label="Reels"], div[role="menuitem"][aria-label="Reels"],
        header a[href*="reel"], svg path[d*="M490.225"], div[data-bloks-id*="reels"],
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
    `;
    document.head.appendChild(style);

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
            }, { passive: false, capture: false });

            // Block wheel
            document.addEventListener('wheel', function(e) {
                e.preventDefault();
                returnToChat();
            }, { passive: true, capture: true });

            // Block click on background (not on interactive elements)
            document.addEventListener('click', function(e) {
                var target = e.target;
                if (!target.closest('button, a, [role="button"], input, textarea')) {
                    e.preventDefault();
                    returnToChat();
                }
            }, { passive: true, capture: true });
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

            // Hide divs with instagram images (post thumbnails) - but not profile pics or search input
            var postThumbs = document.querySelectorAll('div img[src*="instagram"], div img[src*="cdninstagram"]');
            postThumbs.forEach(function(img) {
                var parent = img.closest('div');
                // Check if it's a profile picture (usually small, in header or nav)
                var isProfilePic = img.getAttribute('src') && (
                    img.getAttribute('src').includes('profile') ||
                    img.getAttribute('src').includes('profiles') ||
                    parent.querySelector('header') ||
                    parent.querySelector('nav') ||
                    img.width < 100 || img.height < 100
                );
                if (parent && !parent.querySelector('input') && !isProfilePic) {
                    parent.style.display = 'none';
                }
            });

            // Hide spinner and show "No reels" message
            var spinners = document.querySelectorAll('svg circle, div[role="progressbar"], div[class*="spinner"], div[class*="loader"]');
            spinners.forEach(function(el) {
                el.style.display = 'none';
            });

            // Add "No reels" message if not already added
            if (!document.getElementById('no-reels-msg')) {
                var msg = document.createElement('div');
                msg.id = 'no-reels-msg';
                msg.textContent = 'No reels to see here';
                msg.style.cssText = 'position:fixed;top:50%;left:50%;transform:translate(-50%,-50%);font-size:18px;color:#666;z-index:999;font-family:sans-serif;text-align:center;';
                document.body.appendChild(msg);
            }
        } else {
            // Remove message when leaving explore/search
            var msg = document.getElementById('no-reels-msg');
            if (msg) msg.remove();
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
            self?.progressView.isHidden = progress >= 90.0
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
        progressView.isHidden = true
        progressView.setProgress(0.1, animated: true)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
