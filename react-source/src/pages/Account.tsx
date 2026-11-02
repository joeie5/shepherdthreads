import React from 'react';
import { Navigate, useParams } from 'react-router-dom';
import { useStore } from '../contexts/StoreContext';
import { AccountShell, accountTabs } from '../components/account/AccountShell';
import { ProfilePanel } from '../components/account/ProfilePanel';
import { OrdersPanel } from '../components/account/OrdersPanel';
import { AddressesPanel } from '../components/account/AddressesPanel';
import { WishlistPanel } from '../components/account/WishlistPanel';
import { PaymentsPanel } from '../components/account/PaymentsPanel';

const panels: Record<string, React.ReactNode> = {
  profile: <ProfilePanel />,
  orders: <OrdersPanel />,
  addresses: <AddressesPanel />,
  wishlist: <WishlistPanel />,
  payments: <PaymentsPanel />
};

export function Account() {
  const { tab = 'profile' } = useParams();
  const { isSignedIn } = useStore();
  if (!isSignedIn) return <Navigate to="/login" replace />;
  if (!accountTabs.some((t) => t.id === tab)) return <Navigate to="/account" replace />;
  return <AccountShell active={tab}>{panels[tab]}</AccountShell>;
}