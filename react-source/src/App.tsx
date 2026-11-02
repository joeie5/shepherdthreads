import React from 'react';
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import { StoreProvider } from './contexts/StoreContext';
import { Layout } from './components/Layout';
import { Home } from './pages/Home';
import { Shop } from './pages/Shop';
import { Collections } from './pages/Collections';
import { ProductDetail } from './pages/ProductDetail';
import { Cart } from './pages/Cart';
import { Checkout } from './pages/Checkout';
import { Search } from './pages/Search';
import { Auth } from './pages/Auth';
import { Account } from './pages/Account';
import { OrderDetail } from './pages/OrderDetail';
import { OurStory } from './pages/OurStory';
import { Journal } from './pages/Journal';
import { Article } from './pages/Article';
import { Contact } from './pages/Contact';
import { Faq } from './pages/Faq';
import { NotFound } from './pages/NotFound';

export function App() {
  return (
    <BrowserRouter>
      <StoreProvider>
        <Routes>
          <Route element={<Layout />}>
            <Route index element={<Home />} />
            <Route path="shop" element={<Shop />} />
            <Route path="collections" element={<Collections />} />
            <Route path="product/:productId" element={<ProductDetail />} />
            <Route path="cart" element={<Cart />} />
            <Route path="checkout" element={<Checkout />} />
            <Route path="search" element={<Search />} />
            <Route path="login" element={<Auth />} />
            <Route path="account" element={<Account />} />
            <Route path="account/orders/:orderId" element={<OrderDetail />} />
            <Route path="account/:tab" element={<Account />} />
            <Route path="wishlist" element={<Navigate to="/account/wishlist" replace />} />
            <Route path="our-story" element={<OurStory />} />
            <Route path="journal" element={<Journal />} />
            <Route path="journal/:slug" element={<Article />} />
            <Route path="contact" element={<Contact />} />
            <Route path="faq" element={<Faq />} />
            <Route path="*" element={<NotFound />} />
          </Route>
        </Routes>
      </StoreProvider>
    </BrowserRouter>);

}