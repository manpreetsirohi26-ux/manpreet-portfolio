# Manpreet Sirohi portfolio + admin panel (Supabase)

Ye folder aapka poora portfolio hai. Design wahi hai, bas ab projects, tools aur page text admin page se badal sakte ho, aur visitors ke messages Supabase me save hote hain.

## Files

| File | Kaam |
|---|---|
| `index.html` | Aapka portfolio (design wahi, data Supabase se) |
| `admin.html` | Admin page (login, projects, tools, page text, messages) |
| `config.js` | Supabase URL aur anon key (already filled) |
| `supabase.sql` | Tables, security rules (RLS), storage aur starter data banata hai |
| `setpassword.sql` | Admin ka password reset karne ke liye (optional) |
| `sydney-immigration.jpg`, `zero-kata.jpg`, `studymate-ai.jpg` | 3 projects ke cover photos |
| `robots.txt` | Google ko batata hai ki admin page na dikhaye |

## Setup (ek baar)

1. **Supabase project banao:** supabase.com par free account, phir New project.
2. **SQL chalao:** Supabase me **SQL Editor -> New query**. `supabase.sql` ka poora code paste karo aur **Run** dabao. "Success" dikhna chahiye.
3. **Admin user banao:** **Authentication -> Users -> Add user -> Create new user**. Email `manpreetsirohi26@gmail.com` rakho (wahi, warna aap admin nahi maani jaogi), apna password daalo, aur **Auto Confirm User** on rakho.
4. **Naye signup band karo:** **Authentication -> Sign In / Providers** (ya Settings) me **Allow new users to sign up** ko **off** karo. Isse koi aur account nahi bana sakega.
5. **Key check karo:** `config.js` me aapki Supabase URL aur anon key already set hai. Agar naya project banaya hai to **Project Settings -> API** se URL aur **anon public key** copy karke wahan paste karo. Sirf **anon** key, kabhi **service_role** nahi.

### Password bhool gaye?

Supabase **SQL Editor** me `setpassword.sql` paste karke Run karo. Password `Admin@12345` set ho jayega (baad me badal lena).

## Apne computer par test karna (Codespace me)

Terminal me:
```
python3 -m http.server 8000
```
Ports tab me 8000 par "Open in Browser" dabao. Portfolio khulega. Address ke aakhir me `/admin.html` jodo to admin page khulega.

## Online daalna (Vercel)

1. Is folder ki saari files (jpg covers ke saath) GitHub repo me daalo.
2. Vercel me **Add New Project** se repo import karo. Koi build setting nahi chahiye.
3. Online link par `/admin.html` kholo aur login karo.

## Dhyan rakhna

- **service_role key** kabhi website, GitHub ya kisi ko mat dena.
- Security rules `supabase.sql` me hain. Unhe mat hatana, warna data khula ho jaayega.
- Agar Supabase ya config.js sahi nahi hai, to portfolio apna purana content hi dikhata hai, kuch toot'ta nahi.
- Admin me kisi project ko delete karne par uski photo storage me bachi rehti hai (free space ke liye kabhi kabhi Storage me saaf kar sakti ho).
- Free plan ki limits badalti rehti hain, supabase.com par check kar lena.
