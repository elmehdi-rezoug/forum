-- USERS
CREATE TABLE IF NOT EXISTS USERS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
);

-- SESSIONS
CREATE TABLE IF NOT EXISTS SESSIONS (
    id TEXT PRIMARY KEY UNIQUE, -- uuid
    expires_at DATETIME NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- POSTS
CREATE TABLE IF NOT EXISTS POSTS (
    id         INTEGER  NOT NULL UNIQUE,
    user_id    INTEGER  NOT NULL,
    created_at DATETIME NOT NULL, -- ~ 1GB
    title      TEXT     NULL    ,
    text       TEXT     NULL    ,
    PRIMARY KEY (id AUTOINCREMENT),
    FOREIGN KEY (user_id) REFERENCES USERS (id) ON DELETE CASCADE
);

---CATEGORY 
CREATE TABLE IF NOT EXISTS CATEGORY (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

---category post 
CREATE TABLE IF NOT EXISTS POST_CATEGORY (
    post_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,

    PRIMARY KEY (post_id, category_id),

    FOREIGN KEY (post_id) REFERENCES POSTS(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES CATEGORY(id) ON DELETE CASCADE
);

-- COMMENTS
CREATE TABLE IF NOT EXISTS COMMENTS (
    id         INTEGER  NOT NULL UNIQUE,
    user_id    INTEGER  NOT NULL,
    post_id    INTEGER  NOT NULL,
    created_at DATETIME NOT NULL,
    text       TEXT     NULL    ,
    PRIMARY KEY (id AUTOINCREMENT),
    FOREIGN KEY (user_id) REFERENCES USERS (id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES POSTS (id) ON DELETE CASCADE 
);

-- POST REACTIONS
CREATE TABLE IF NOT EXISTS POST_REACTIONS (
  user_id INTEGER NOT NULL,
  post_id INTEGER NOT NULL,
  is_like INTEGER NOT NULL DEFAULT 1,
  FOREIGN KEY (user_id) REFERENCES USERS (id) ON DELETE CASCADE,
  FOREIGN KEY (post_id) REFERENCES POSTS (id) ON DELETE CASCADE 
);
-- reactions are unique by combination of both user_id and post_id

-- COMMENT REACTIONS
CREATE TABLE IF NOT EXISTS COMMENT_REACTIONS (
  user_id INTEGER NOT NULL,
  comment_id INTEGER NOT NULL,
  is_like INTEGER NOT NULL DEFAULT 1, -- 1 for like / -1 for dislike
  FOREIGN KEY (user_id) REFERENCES USERS (id) ON DELETE CASCADE ,
  FOREIGN KEY (comment_id) REFERENCES COMMENTS (id) ON DELETE CASCADE 
);

--Rate Limits
CREATE TABLE IF NOT EXISTS rate_limits (
    ip TEXT NOT NULL,
    route TEXT NOT NULL,
    last_request DATETIME NOT NULL,
    PRIMARY KEY (ip, route)
);

--Categories
INSERT OR IGNORE INTO CATEGORY (name) VALUES 
('General'),
('Lifestyle'),
('Health & Fitness'),
('Travel'),
('Food & Cooking'),
('Education'),
('Business'),
('Finance'),
('Entertainment'),
('Sports'),
('Personal Dev'),
('Culture'),
('News');

-- Users (passwords are bcrypt of "password123")
INSERT OR IGNORE INTO USERS (name, email, password) VALUES
('alex_dev', 'alex@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LjZAH9b8oS6'),
('sara_m', 'sara@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LjZAH9b8oS6'),
('karim_tech', 'karim@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LjZAH9b8oS6'),
('lina_codes', 'lina@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LjZAH9b8oS6'),
('youssef_b', 'youssef@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LjZAH9b8oS6'),
('hamza_oujda', 'hamza@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LjZAH9b8oS6'),
('fatima_zhr', 'fatima@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LjZAH9b8oS6'),
('amine_rbat', 'amine@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LjZAH9b8oS6'),
('nadia_casa', 'nadia@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LjZAH9b8oS6'),
('omar_dev', 'omar@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LjZAH9b8oS6');

-- Posts
INSERT OR IGNORE INTO POSTS (user_id, created_at, title, text) VALUES
(1, datetime('now', '-7 days'), 'Why Go is great for backend dev', 'After 2 years with Node.js I switched to Go and never looked back. The simplicity, performance, and concurrency model are unmatched for building APIs.'),
(2, datetime('now', '-6 days'), 'My study routine as a CS student', 'I use the Pomodoro technique: 25 min focus, 5 min break. After 4 cycles I take a longer break. Consistency > intensity.'),
(3, datetime('now', '-5 days'), 'Docker changed how I deploy apps', 'Before Docker, deploying was a nightmare. Now I build an image, push it, and run it anywhere. The Dockerfile in this project is a good starting point.'),
(4, datetime('now', '-4 days'), 'Best resources to learn algorithms', 'NeetCode 150, CLRS for theory, and just grind LeetCode. Focus on patterns not memorization.'),
(5, datetime('now', '-3 days'), 'Remote work tips that actually work', 'Separate your workspace from your rest space. Set hard stop times. Communicate more than you think you need to — async teams live by over-communication.'),
(6, datetime('now', '-3 days'), 'Mon expérience à Zone01 Oujda', 'Rejoindre Zone01 a changé ma façon de voir la programmation. On apprend par les pairs, pas par les cours magistraux. C''est intense mais ça forge vraiment.'),
(7, datetime('now', '-2 days'), 'Conseils pour débuter en développement web', 'Commencez par HTML/CSS, puis JavaScript vanilla avant de toucher aux frameworks. Beaucoup sautent les bases et galèrent ensuite. Les fondations, c''est tout.'),
(8, datetime('now', '-2 days'), 'Git workflow en équipe — ce qui fonctionne vraiment', 'On a adopté le trunk-based development avec des feature flags. Plus de branches qui traînent des semaines. Moins de conflits de merge, plus de livraisons.'),
(9, datetime('now', '-1 days'), 'Pourquoi j''ai arrêté de comparer mon niveau aux autres', 'Sur LinkedIn on voit que des succès. La vraie progression c''est de se comparer à soi-même d''il y a 6 mois. Focus sur ta courbe, pas celle des autres.'),
(10, datetime('now', '-12 hours'), 'SQLite en production — vraiment viable ?', 'Pour des projets avec un trafic modéré, SQLite est largement suffisant. Pas de serveur à gérer, les backups sont un simple fichier. On l''utilise sur ce forum d''ailleurs.');

-- Post categories
INSERT OR IGNORE INTO POST_CATEGORY (post_id, category_id) VALUES
(1, (SELECT id FROM CATEGORY WHERE name='Education')),
(1, (SELECT id FROM CATEGORY WHERE name='Business')),
(2, (SELECT id FROM CATEGORY WHERE name='Personal Dev')),
(2, (SELECT id FROM CATEGORY WHERE name='Education')),
(3, (SELECT id FROM CATEGORY WHERE name='Education')),
(3, (SELECT id FROM CATEGORY WHERE name='General')),
(4, (SELECT id FROM CATEGORY WHERE name='Education')),
(5, (SELECT id FROM CATEGORY WHERE name='Lifestyle')),
(5, (SELECT id FROM CATEGORY WHERE name='Personal Dev')),
(6, (SELECT id FROM CATEGORY WHERE name='Education')),
(6, (SELECT id FROM CATEGORY WHERE name='Personal Dev')),
(7, (SELECT id FROM CATEGORY WHERE name='Education')),
(7, (SELECT id FROM CATEGORY WHERE name='General')),
(8, (SELECT id FROM CATEGORY WHERE name='Education')),
(8, (SELECT id FROM CATEGORY WHERE name='Business')),
(9, (SELECT id FROM CATEGORY WHERE name='Personal Dev')),
(9, (SELECT id FROM CATEGORY WHERE name='Lifestyle')),
(10, (SELECT id FROM CATEGORY WHERE name='Education')),
(10, (SELECT id FROM CATEGORY WHERE name='General'));

-- Comments
INSERT OR IGNORE INTO COMMENTS (user_id, post_id, created_at, text) VALUES
-- post 1 (Go)
(6, 1, datetime('now', '-6 days', '+2 hours'), 'Go m''a aussi convaincu après avoir souffert avec les callbacks en Node. La lisibilité du code est incomparable.'),
(7, 1, datetime('now', '-6 days', '+5 hours'), 'The goroutine model alone is worth the switch.'),
(2, 1, datetime('now', '-6 days', '+8 hours'), 'What about the ecosystem though? npm has way more packages.'),
-- post 2 (study routine)
(8, 2, datetime('now', '-5 days', '+1 hours'), 'La technique Pomodoro est sous-estimée. Je la combine avec le time-blocking et ça double ma productivité.'),
(3, 2, datetime('now', '-5 days', '+3 hours'), 'How do you handle deep focus tasks that need more than 25 minutes?'),
-- post 3 (Docker)
(9, 3, datetime('now', '-4 days', '+2 hours'), 'Les multi-stage builds sont une révolution pour garder des images légères.'),
(1, 3, datetime('now', '-4 days', '+4 hours'), 'Docker Compose for local dev + single Dockerfile for prod is my go-to setup.'),
(10, 3, datetime('now', '-4 days', '+6 hours'), 'On utilise exactement ce setup sur ce projet. Fonctionne parfaitement.'),
-- post 4 (algorithms)
(5, 4, datetime('now', '-3 days', '+1 hours'), 'NeetCode is 🔥. His explanations are way clearer than most paid courses.'),
(6, 4, datetime('now', '-3 days', '+2 hours'), 'La reconnaissance de patterns plutôt que la mémorisation — c''est le vrai conseil que personne ne donne.'),
-- post 5 (remote work)
(7, 5, datetime('now', '-2 days', '+2 hours'), 'L''heure de fin fixe est énorme. Avant je travaillais jusqu''à minuit et je burnoutais chaque semaine.'),
(4, 5, datetime('now', '-2 days', '+4 hours'), 'Async-first communication saved our team. We use Loom for video updates instead of meetings.'),
-- post 6 (Zone01)
(1, 6, datetime('now', '-2 days', '+3 hours'), 'Peer learning scales way better than lectures. You retain more when you teach others.'),
(3, 6, datetime('now', '-2 days', '+5 hours'), 'C''est exactement ce qu''il manque aux universités classiques — apprendre en faisant, pas en écoutant.'),
(8, 6, datetime('now', '-2 days', '+7 hours'), 'Zone01 change des vies. L''accès gratuit à une formation de qualité, c''est rare.'),
-- post 7 (web dev tips)
(2, 7, datetime('now', '-1 days', '+1 hours'), 'Totally agree. I see people struggling with React who don''t even understand the DOM.'),
(9, 7, datetime('now', '-1 days', '+3 hours'), 'JavaScript vanilla d''abord — ça devrait être une règle obligatoire avant tout framework.'),
-- post 8 (git workflow)
(5, 8, datetime('now', '-1 days', '+2 hours'), 'Trunk-based with feature flags is the move. Long-lived branches are a form of technical debt.'),
(7, 8, datetime('now', '-1 days', '+4 hours'), 'On a essayé GitFlow, c''était un enfer. Le trunk-based est bien plus simple à tenir sur la durée.'),
-- post 9 (comparison)
(10, 9, datetime('now', '-18 hours'), 'Ce post m''a parlé. LinkedIn donne l''impression que tout le monde réussit tout instantanément.'),
(4, 9, datetime('now', '-14 hours'), 'Compare yourself to who you were yesterday — Jordan Peterson avait raison sur ce point.'),
-- post 10 (SQLite)
(1, 10, datetime('now', '-10 hours'), 'SQLite with WAL mode handles concurrent reads really well. Underrated for small-to-mid projects.'),
(6, 10, datetime('now', '-6 hours'), 'Le fait que le backup soit juste un fichier à copier — c''est un argument massif pour les petites équipes.');

-- Post reactions
INSERT OR IGNORE INTO POST_REACTIONS (user_id, post_id, is_like) VALUES
(2,1,1),(3,1,1),(4,1,1),(5,1,1),(6,1,1),(7,1,1),(9,1,1),
(1,2,1),(3,2,1),(5,2,1),(8,2,1),(10,2,1),
(1,3,1),(2,3,1),(4,3,1),(5,3,1),(7,3,1),(9,3,1),
(1,4,1),(2,4,1),(3,4,1),(6,4,1),(8,4,1),
(1,5,1),(2,5,1),(3,5,1),(4,5,1),(6,5,1),(9,5,1),
(1,6,1),(2,6,1),(3,6,1),(4,6,1),(5,6,1),(8,6,1),(10,6,1),
(1,7,1),(3,7,1),(5,7,1),(6,7,1),(8,7,1),(10,7,1),
(1,8,1),(2,8,1),(4,8,1),(6,8,1),(9,8,1),
(1,9,1),(2,9,1),(4,9,1),(6,9,1),(7,9,1),(8,9,1),(10,9,1),
(2,10,1),(3,10,1),(4,10,1),(5,10,1),(7,10,1),(8,10,1);

-- Comment reactions
INSERT OR IGNORE INTO COMMENT_REACTIONS (user_id, comment_id, is_like) VALUES
(1,1,1),(4,1,1),(5,1,1),(9,1,1),
(2,2,1),(4,2,1),(8,2,1),
(6,3,1),(7,3,1),
(1,4,1),(2,4,1),(9,4,1),
(6,5,1),(8,5,1),
(2,6,1),(3,6,1),(5,6,1),(7,6,1),
(4,7,1),(6,7,1),(9,7,1),
(1,8,1),(3,8,1),
(1,9,1),(2,9,1),(4,9,1),(8,9,1),
(5,10,1),(7,10,1),(9,10,1),
(3,11,1),(6,11,1),(8,11,1),
(1,12,1),(5,12,1),(9,12,1),(10,12,1),
(2,13,1),(4,13,1),(7,13,1),
(1,14,1),(3,14,1),(6,14,1),(8,14,1),(10,14,1),
(4,15,1),(7,15,1),(9,15,1),
(3,16,1),(5,16,1),(8,16,1),
(1,17,1),(2,17,1),(6,17,1),
(4,18,1),(7,18,1),(9,18,1),(10,18,1),
(2,19,1),(5,19,1),(8,19,1),
(1,20,1),(3,20,1),(6,20,1),(9,20,1),
(4,21,1),(7,21,1),(10,21,1),
(2,22,1),(5,22,1),(8,22,1);
